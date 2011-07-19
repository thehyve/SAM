package org.dbxp.sam

import grails.converters.JSON
import org.dbnp.gdt.Template
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class FeatureController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }
	
    def list = {
        [featureInstanceList: Feature.list(params), featureInstanceTotal: Feature.count()]
    }
	
	/**
	 * Returns data for datatable. 
	 * @see http://www.datatables.net/usage/server-side
	 * @see dbxpModuleBase/datatables.js
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
		String search = params.int( 'sSearch' );
		
		// Sort parameters
		int sortingCols = params.int( 'iSortingCols' );
		List sortOn = []
		for( int i = 0; i < sortingCols; i++ ) {
			sortOn[ i ] = [ 'column': params.int( 'iSortCol_' + i ) + 1, 'direction': params[ 'sSortDir_' + i ] ];
		}
		
		// What columns to return?
		def columns = [ 'name', 'unit' ]
		
		// Create the HQL query
		def hqlParams = [:];
		def hql = "FROM Feature f ";
		def orderHQL = "";
		
		// Search properties
		if( search ) {
			hqlParams[ "search" ] = "%" + search + "%"
			
			def hqlConstraints = [];
			for( int i = 0; i < 2; i++ ) {
				hqlConstraints << columns[ i ] + " LIKE :search"
			}

			// Group names should be searched separately
			hqlConstraints << "EXISTS ( FROM FeatureGroup fg, FeaturesAndGroups fag WHERE fg = fag.featureGroup AND fag.feature = f AND fg.name LIKE :search"
			
			hql += "WHERE " + hqlConstraints.join( " OR " ) + " "
		}
			
		// Sort properties
		if( sortOn ) {
			orderHQL = "ORDER BY " + sortOn.collect { it.column + " " + it.direction }.join( " " ); 
		}

		// Display properties
		def records = Feature.executeQuery( hql + orderHQL, hqlParams, [ max: displayLength, offset: displayStart ] );
		def numTotalRecords = Feature.count();
		def filteredRecords = Feature.executeQuery( "SELECT id " + hql, hqlParams );
		
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
				[ it.name, it.unit, it.getFeatureGroups()*.name?.join( ", " ), '', '', '']
			},
			aIds: filteredRecords 
		]
		
		response.setContentType( "application/json" );
		render returnValues as JSON
		
	}

    def create = {
        def featureInstance = new Feature()
        featureInstance.properties = params
        return [featureInstance: featureInstance]
    }

    def save = {
        def featureInstance = new Feature(params)
        if (featureInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'feature.label', default: 'Feature'), featureInstance.id])}"
            if(params?.nextPage=="edit"){
                redirect(action: "edit", id: featureInstance.id, featureInstance: featureInstance)
            } else {
                redirect(action: "list")
            }
        }
        else {
            render(view: "create", model: [featureInstance: featureInstance])
        }
    }

    def show = {
        def featureInstance = Feature.get(params.id)
        if (!featureInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'feature.label', default: 'Feature'), params.id])}"
            redirect(action: "list")
        }
        else {
            [featureInstance: featureInstance]
        }
    }

    def edit = {
        def featureInstance = Feature.get(params.id)
        session.featureInstance = featureInstance
        if (!featureInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'feature.label', default: 'Feature'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [featureInstance: featureInstance]
        }
    }

    def update = {
        def featureInstance = Feature.get(params.id)
        if (featureInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (featureInstance.version > version) {

                    featureInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'feature.label', default: 'Feature')] as Object[], "Another user has updated this Feature while you were editing")
                    render(view: "edit", model: [featureInstance: featureInstance])
                    return
                }
            }
			
			// did the study template change?
			if( params.template && params.template != featureInstance.template?.name ) {
				featureInstance.changeTemplate( params.template );
			}

            // does the study have a template set?
            if (featureInstance.template) {
                // yes, iterate through template fields
                featureInstance.giveFields().each() {
                    // and set their values
                    featureInstance.setFieldValue(it.name, params.get(it.escapedName()))
                }
            }

			// Remove the template parameter, since it is a string and that troubles the 
			// setting of properties.
			params.remove( 'template' ) 
			
            featureInstance.properties = params
            if (!featureInstance.hasErrors() && featureInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'feature.label', default: 'Feature'), featureInstance.id])}"
                redirect(action: "show", id: featureInstance.id)
            }
            else {
                render(view: "edit", model: [featureInstance: featureInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'feature.label', default: 'Feature'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def featureInstance = Feature.get(params.id)
        if (featureInstance) {
            def FaGList = FeaturesAndGroups.findAllByFeature(featureInstance)
            try {
                if(FaGList.size()!=0){
                    FaGList.each {
                        it.delete(flush: true)
                    }
                }
                featureInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'feature.label', default: 'Feature'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                log.error(e)
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'feature.label', default: 'Feature'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'feature.label', default: 'Feature'), params.id])}"
            redirect(action: "list")
        }
    }

    def refreshEdit = {
        // Used to refresh the edit page after a change of template
        if(!session.featureInstance.isAttached()){
            session.featureInstance.attach()
        }
        updateTemplate()
        render(view: "edit", model: [featureInstance: session.featureInstance])
    }

    def confirmNewFeatureGroup = {
        // Used to add a new FeaturesAndGroups connection and to refresh the edit page's feature group list
        if(!session.featureInstance.isAttached()){
            session.featureInstance.attach()
        }
        if(params?.newFeatureGroupID) {
            // Creating a new group
            FeaturesAndGroups.create(FeatureGroup.get(params.newFeatureGroupID), session.featureInstance);
			println "Association created"
        }

        // This featureInstance is only used to display an accurate list
        def featureInstance = Feature.get(params.id)
		showFaGList( featureInstance );
    }
	
	protected def showFaGList( featureInstance ) {
		def groupList = FeaturesAndGroups.findAllByFeature(featureInstance)
		def remainingGroups 
		
		if( groupList )
			remainingGroups = FeatureGroup.executeQuery( "FROM FeatureGroup fg WHERE fg NOT IN (:groups)", [ 'groups': groupList*.featureGroup ] )
		else
			remainingGroups = FeatureGroup.list()
			
		render(view: "FaGList", model: [groupList: groupList, remainingGroups: remainingGroups])
	}

    def templateSpecific = {
        // Get a list of template specific fields
        def featureInstance = Feature.get(params.id)
        render(view: "templateSpecific", model: [featureInstance: featureInstance])
    }

    def templateSelection = {
        // Get a template selector
        // Actually using this in a .gsp does not seem to lead to a working template editor
        // TODO: fix this so that add/modify does not have to lead to a page refresh
        def featureInstance = Feature.get(params.id)
        render(view: "templateSelection", model: [featureInstance: featureInstance])
    }

	def updateTemplate = {
        // A different template has been selected, so all the template fields have to be removed, added or updated with their previous values (they start out empty)
       if(!session.featureInstance.isAttached()){
           session.featureInstance.attach()
       }
       try {
            if(params.template==""){
                println "Removing template..."
                session.featureInstance.template = null
            } else if(params?.template && session?.featureInstance.template?.name != params.get('template')) {
               // set the template
                println "params.template : "+params.template
               session.featureInstance.template = Template.findByName(params.template)
           }

            println "Updating template..."
           // does the study have a template set?
           if (session.featureInstance.template && session.featureInstance.template instanceof Template) {
               // yes, iterate through template fields
               session.featureInstance.giveFields().each() {
                   // and set their values
                   session.featureInstance.setFieldValue(it.name, params.get(it.escapedName()))
               }
           }
       } catch (Exception e){
           log.error(e)
            e.printStackTrace()
           // TODO: Make this more informative
           flash.message = "An error occurred while updating this feature's template. Please try again.<br>${e}"
       }
   }

    def removeFromGroup = {
        // Used to delete a FeaturesAndGroups connection
        if(!session.featureInstance.isAttached()){
            session.featureInstance.attach()
        }
		
        // Clear message so no message will be shown if everything is OK
		flash.message = "";
		
        try {
            // Try to find the featuresAndGroupsInstance that we wish to delete
            def featuresAndGroupsInstance = FeaturesAndGroups.get(params.fagId)
			
			if(featuresAndGroupsInstance==null){
				// We could not find the featuresAndGroupsInstance that we wish to remove
				flash.message = "The specified group could not be found. The probable cause for this would be that the group has already been removed."
			} else {
				// We found the featuresAndGroupsInstance that we wish to remove
				def groupName = featuresAndGroupsInstance.featureGroup.name
				def featureID = featuresAndGroupsInstance.feature.id
	
				// Proceed with deletion
				try {
					featuresAndGroupsInstance.delete(flush: true)
				} catch (org.springframework.dao.DataIntegrityViolationException e) {
					log.error(e)
					flash.message = "There has been a problem with removing the group ${groupName} from this feature.<br>${e}"
				}
			}
        } catch (Exception e){
            log.error(e)
            // An error occurred while fetching the featuresAndGroupsInstance that we wish to remove
            flash.message = "The specified group could not be found.<br>${e}"
        }

		// This featureInstance is only used to display an accurate list
		def featureInstance = Feature.get( params.int( 'id' ) )
		showFaGList( featureInstance );
    }

    def deleteMultiple = {
        // Used to delete multiple features from the feature list
        def toDeleteList = []
        if(params?.fMassDelete!=null){
            // If necessary, go from a string to a list of strings
            if(params.fMassDelete.class!="".class){
                toDeleteList = params.fMassDelete
            } else {
                toDeleteList.push(params.fMassDelete)
            }
        }
        if(toDeleteList.size()>0){
            def return_map = [:]
            return_map = Feature.deleteMultipleFeatures(toDeleteList)
            def error = return_map.get("error")
            if(error){
                log.error(error)
            }
            def message = return_map.get("message")
            if(message){
                flash.message = message
            }
            def action = return_map.get("action")
            if(action){
                redirect(action: action)
            } else {
                redirect(action:list)
            }
        } else {
            flash.message = "No features were marked when the delete button was clicked, so no features were deleted."
            redirect(action: "list")
        }
    }
}