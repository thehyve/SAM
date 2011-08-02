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
			hqlConstraints << "EXISTS ( FROM FeatureGroup fg, FeaturesAndGroups fag WHERE fg = fag.featureGroup AND fag.feature = f AND fg.name LIKE :search)";
			
			hql += "WHERE " + hqlConstraints.join( " OR " ) + " "

            println(hql);
		}
			
		// Sort properties
		if( sortOn ) {
			orderHQL = "ORDER BY " + sortOn.collect { columns[it.column] + " " + it.direction }.join( " " );
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
				[ it.id, it.name, it.unit, it.getFeatureGroups()*.name?.join( ", " ),
                    dt.buttonShow(id: it.id, controller: "feature", blnEnabled: true),
                    dt.buttonEdit(id: it.id, controller: "feature", blnEnabled: true),
                    dt.buttonDelete(id: it.id, controller: "feature", blnEnabled: true)]
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
            flash.message = "The feature ${featureInstance.name} has been created."
            if(params?.nextPage=="edit"){
                redirect(action: "edit", id: featureInstance.id, featureInstance: featureInstance)
            } else {
                if(params?.nextPage=="minimalCreate"){
                    redirect(action: "minimalCreate")
                } else {
                    if(params?.nextPage=="minimalEdit"){
                        redirect(action: "minimalEdit", id: featureInstance.id, featureInstance: featureInstance)
                    } else {
                        redirect(action: "list")
                    }
                }
            }
        }
        else {
            render(view: "create", model: [featureInstance: featureInstance])
        }
    }

    def show = {
        def featureInstance = Feature.get(params.id)
        if (!featureInstance) {
            flash.message = "The requested feature could not be found."
            redirect(action: "list")
        }
        else {
            [featureInstance: featureInstance]
        }
    }

    def edit = {
        def featureInstance = Feature.get(params.id)
        if (!featureInstance) {
            flash.message = "The requested feature could not be found."
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

                    featureInstance.errors.rejectValue("Another user has updated this feature while you were editing. Because of this, your changes have not been saved to the database.")
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
                flash.message = "The feature has been updated."
                redirect(action: "show", id: featureInstance.id)
            }
            else {
                render(view: "edit", model: [featureInstance: featureInstance])
            }
        }
        else {
            flash.message = "The requested feature could not be found."
            redirect(action: "list")
        }
    }

    def delete = {
        def ids = params.list( 'ids' ).findAll { it.isLong() }.collect { it.toDouble() };
		
		if( !ids ) {
			response.sendError( 404 );
			return;
		}
		
		def numDeleted = 0;
		def numErrors = 0;
		def numNotFound = 0;
		
		ids.each { id ->
			def featureInstance = Feature.get(id)
	        if (featureInstance) {
	            def FaGList = FeaturesAndGroups.findAllByFeature(featureInstance)
	            try {
	                if(FaGList.size()!=0){
	                    FaGList.each {
	                        it.delete(flush: true)
	                    }
	                }
	                featureInstance.delete(flush: true)
					numDeleted++;
	            }
	            catch (org.springframework.dao.DataIntegrityViolationException e) {
	                log.error(e)
					numErrors++;
	            }
	        }
	        else {
				numNotFound++;
	        }
		}
		
		if( numDeleted == 1  )
			flash.message = "1 feature has been deleted from the database"
		if( numDeleted > 1 )
			flash.message = numDeleted + " features have been deleted from the database"
		
		flash.error = ""
		if( numNotFound == 1 )
			flash.error += "1 feature has been deleted before." 
		if( numNotFound > 1 )
			flash.error += numNotFound+ " features have been deleted before." 

		if( numErrors == 1 )
			flash.error += "1 feature could not be deleted. Please try again" 
		if( numErrors > 1 )
			flash.error += numErrors + " features could not be deleted. Please try again" 
		
		redirect(action: "list")
    }

    def refreshEdit = {
        println "\n\n\n\n\nparams: "+params
        def featureInstance = Feature.get(params.id)
        featureInstance.getDomainFields().each {
            if(params[it?.name]!=null){
                featureInstance.setProperty(it.name, params[it.name])
            }
        }

        if(params.template!=""){
            updateTemplate()
        }
        
        render(view: "edit", model: [featureInstance: featureInstance])
    }

    def confirmNewFeatureGroup = {
        // Used to add a new FeaturesAndGroups connection and to refresh the edit page's feature group list
        def featureInstance = Feature.get(params.id)
        if(params?.newFeatureGroupID) {
            // Creating a new group
            if( FeaturesAndGroups.create(FeatureGroup.get(params.newFeatureGroupID), featureInstance, true ) ) {
			    println "Association created"
            } else {
                println "Association already existed"
            }
        }

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
        def featureInstance = Feature.get(params.id)
        render(view: "templateSpecific", model: [featureInstance: featureInstance])
    }

    def templateSelection = {
        // Get a template selector
        def featureInstance = Feature.get(params.id)
        def template = featureInstance?.template
        render(view: "templateSelection", model: [template: template])
    }

    def returnUpdatedTemplateSpecificFields = {
        // A different template has been selected, so all the template fields have to be removed, added or updated with their previous values (they start out empty)
        if(params.templateEditorHasBeenOpened!='true'){
            try {
                def featureInstance = Feature.get(params.id)
                if(params.template==""){
                    featureInstance.template = null
                } else if(params?.template && featureInstance.template?.name != params.get('template')) {
                    // set the template
                    featureInstance.template = Template.findByName(params.template)
                }
                // does the study have a template set?
                if (featureInstance.template && featureInstance.template instanceof Template) {
                    // yes, iterate through template fields
                    featureInstance.giveFields().each() {
                        // and set their values
                        featureInstance.setFieldValue(it.name, params.get(it.escapedName()))
                    }
                }
            } catch (Exception e){
               log.error(e)
                e.printStackTrace()
               // TODO: Make this more informative
               flash.message = "An error occurred while updating this feature's template. Please try again.<br>${e}"
            }
        }
        render(view: "templateSpecific", model: [featureInstance: featureInstance])
    }

	def updateTemplate = {
        // A different template has been selected, so all the template fields have to be removed, added or updated with their previous values (they start out empty)
        try {
            def featureInstance = Feature.get(params.id)
            if(params.template==""){
                //println "Removing template..."
                featureInstance.template = null
            } else if(params?.template && featureInstance.template?.name != params.get('template')) {
                // set the template
                //println "params.template : "+params.template
                featureInstance.template = Template.findByName(params.template)
            }
            //println "Updating template..."
            // does the study have a template set?
            if (featureInstance.template && featureInstance.template instanceof Template) {
                // yes, iterate through template fields
                featureInstance.giveFields().each() {
                    // and set their values
                    featureInstance.setFieldValue(it.name, params.get(it.escapedName()))
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

        // Clear message so no message will be shown if everything is OK
        flash.FGError = "";
		
        try {
            // Try to find the featuresAndGroupsInstance that we wish to delete
            def featuresAndGroupsInstance = FeaturesAndGroups.get(params.fagId)
			
			if(featuresAndGroupsInstance==null){
				// We could not find the featuresAndGroupsInstance that we wish to remove
				flash.FGError = "The specified group could not be found. The probable cause for this would be that the group has already been removed."
			} else {
				// We found the featuresAndGroupsInstance that we wish to remove
				def groupName = featuresAndGroupsInstance.featureGroup.name
				def featureID = featuresAndGroupsInstance.feature.id
	
				// Proceed with deletion
				try {
					featuresAndGroupsInstance.delete(flush: true)
				} catch (org.springframework.dao.DataIntegrityViolationException e) {
					log.error(e)
					flash.FGError = "There has been a problem with removing the group ${groupName} from this feature.<br>${e}"
				}
			}
        } catch (Exception e){
            log.error(e)
            // An error occurred while fetching the featuresAndGroupsInstance that we wish to remove
            flash.FGError = "The specified group could not be found.<br>${e}"
        }

		// This featureInstance is only used to display an accurate list
		def featureInstance = Feature.get( params.int( 'id' ) )
		showFaGList( featureInstance );
    }

    def retrieveMissingOption = {
        // Used by an AJAX call to enable refreshing part of a page
        def ret = []
        Feature.list().each {
            if(!params.currentOptions.contains(it.id.toString())){
                ret.add(['id':it.id, 'name':it.name])
            }
        }
        render ret as JSON
    }

    def minimalCreate = {
        def featureInstance = new Feature()
        featureInstance.properties = params
        return [featureInstance: featureInstance]
    }

    def minimalShow = {
        [featureInstance: params.featureInstance]
    }
}