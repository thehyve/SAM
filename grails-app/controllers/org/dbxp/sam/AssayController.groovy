package org.dbxp.sam

import grails.converters.JSON
import org.dbxp.moduleBase.Assay;
import org.dbxp.matriximporter.*

class AssayController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
	
	def synchronizationService
	
    def index = {
        redirect(action: "list", params: params)
    }
	
	def synchronize = {
		synchronizationService.initSynchronization( session.sessionToken, session.user ) ;
		synchronizationService.fullSynchronization();
		
		redirect(action: "list", params: params)
	}

    def list = {
		// First synchronize all studies that have been changed
		synchronizationService.initSynchronization( session.sessionToken, session.user );
		synchronizationService.synchronizeChangedStudies()

        [assayInstanceList: Assay.list(params), assayInstanceTotal: Assay.count()]
    }

	/**
	* Returns data for datatable.
	* @see ! http://www.datatables.net/usage/server-side
	* @see ../moduleBase/datatables.js
	*/
   def datatables_list = {
	   /*	Input:
		   int 	iDisplayStart 		Display start point in the current data set.
		   int 	iDisplayLength 		Number of records that the table can display in the current draw. It is expected that the number of records returned will be equal to this number, unless the server has fewer records to return.
		   int 	iColumns 			Number of columns being displayed (useful for getting individual column search info)
		   string 	sSearch 			Global search field
		   bool 	bRegex 				True if the global filter should be treated as a regular expression for advanced filtering, false if not.
		   bool 	bSearchable_(int) 	Indicator for if a column is flagged as searchable or not on the client-side
		   string 	sSearch_(int) 		Individual column filter
		   bool 	bRegex_(int) 		True if the individual column filter should be treated as a regular expression for advanced filtering, false if not
		   bool 	bSortable_(int) 	Indicator for if a column is flagged as sortable or not on the client-side
		   int 	iSortingCols 		Number of columns to sort on
		   int 	iSortCol_(int) 		Column being sorted on (you will need to decode this number for your database)
		   string 	sSortDir_(int) 		Direction to be sorted - "desc" or "asc".
		   string 	mDataProp_(int) 	The value specified by mDataProp for each column. This can be useful for ensuring that the processing of data is independent from the order of the columns.
		   string 	sEcho 				Information for DataTables to use for rendering.
		*/

	   // Display parameters
	   int displayStart = params.int( 'iDisplayStart' );
	   int displayLength = params.int( 'iDisplayLength' );
	   int numColumns = params.int( 'columns' );
	   
	   // Search parameters; searchable columns are determined serverside
	   String search = params.sSearch;

	   // Sort parameters
	   int sortingCols = params.int( 'iSortingCols' );
	   List sortOn = []
	   for( int i = 0; i < sortingCols; i++ ) {
		   sortOn[ i ] = [ 'column': params.int( 'iSortCol_' + i ), 'direction': params[ 'sSortDir_' + i ] ];
	   }
	   
	   // What columns to return?
	   def columns = [ 'name', 'unit' ]
	   
	   // Create the HQL query
	   def hqlParams = [:];
	   def columnsHQL = "SELECT a.id, a.study.name, a.name, COUNT( * ) "
	   def hql = "FROM Assay a ";
	   
	   def joinHQL = " LEFT JOIN a.samples s "
	   def groupByHQL = " GROUP BY a.id, a.study.name, a.name "
	   def whereHQL = "";
	   def orderHQL = "";
	   
	   // Search properties
	   if( search ) {
		   hqlParams[ "search" ] = "%" + search + "%"
		   
		   def hqlConstraints = [];
		   hqlConstraints << "a.name LIKE :search"
		   hqlConstraints << "a.study.name LIKE :search"
		   
		   whereHQL += "WHERE " + hqlConstraints.join( " OR " ) + " "
	   }
		   
	   // Sort properties
	   if( sortOn ) {
		   // column number must be increased by 2, because the database column number start with 1, but
		   // the first column that is retrieved from the database is the id column.
		   orderHQL = "ORDER BY " + sortOn.collect { ( it.column + 2 ) + " " + it.direction }.join( " " );
	   }

	   // Display properties
	   def records = Assay.executeQuery( columnsHQL + hql + joinHQL + whereHQL + groupByHQL + orderHQL, hqlParams, [ max: displayLength, offset: displayStart ] );
	   def numTotalRecords = Assay.count();
	   def filteredRecords = Assay.executeQuery( "SELECT id " + hql + whereHQL, hqlParams );
	   
	   /*
	   int 	iTotalRecords 			Total records, before filtering (i.e. the total number of records in the database)
	   int 	iTotalDisplayRecords 	Total records, after filtering (i.e. the total number of records after filtering has been applied - not just the number of records being returned in this result set)
	   string 	sEcho 					An unaltered copy of sEcho sent from the client side. This parameter will change with each draw (it is basically a draw count) - so it is important that this is implemented. Note that it strongly recommended for security reasons that you 'cast' this parameter to an integer in order to prevent Cross Site Scripting (XSS) attacks.
	   string 	sColumns 				Optional - this is a string of column names, comma separated (used in combination with sName) which will allow DataTables to reorder data on the client-side if required for display. Note that the number of column names returned must exactly match the number of columns in the table. For a more flexible JSON format, please consider using mDataProp.
	   array 	aaData 					The data in a 2D array. Note that you can change the name of this parameter with sAjaxDataProp.
	   */



	   def returnValues = [
		   iTotalRecords: numTotalRecords,
		   iTotalDisplayRecords: filteredRecords.size(),
		   sEcho: params.int( 'sEcho' ),
		   aaData: records.collect { 
			   return ( it as List ) + dt.buttonShow( 'controller': "assay", 'id': it[ 0 ] ) 
		   },
		   aIds: filteredRecords
	   ]
	   
	   response.setContentType( "application/json" );
	   render returnValues as JSON
	   
   }
	
	
    def show = {
		def hideEmpty = params.hideEmpty ? Boolean.parseBoolean( params.hideEmpty ) : true
        def assayInstance = Assay.get(params.id)
		
        if (!assayInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'assay.label', default: 'Assay'), params.id])}"
            redirect(action: "list")
			return
        }
		
		def samples = SAMSample.findAll( "from SAMSample s WHERE s.assay = :assay ORDER BY s.name", [ assay: assayInstance ] );
		def measurements = [];
		def features = [];
		
		if( samples ) {
			measurements = Measurement.findAll( "from Measurement m WHERE m.sample IN (:samples)", [ samples: samples ] );
			if( measurements ) {
				features = Feature.findAll( "from Feature f WHERE EXISTS( FROM Measurement m WHERE m IN (:measurements) )", [ measurements: measurements ] )
			}
		}
		
		return [assayInstance: assayInstance, samples: samples, features: features, measurements: measurements, hideEmpty: hideEmpty] 
    }
}
