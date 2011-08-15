package org.dbxp.sam

import grails.converters.JSON
import org.dbnp.gdt.Template
import org.dbxp.moduleBase.Auth
import org.dbxp.moduleBase.Assay
import org.dbxp.matriximporter.MatrixImporter
import org.dbnp.gdt.TemplateField
import org.springframework.validation.FieldError

class FeatureController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def fuzzySearchService

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
			hqlParams[ "search" ] = "%" + search.toLowerCase() + "%"
			
			def hqlConstraints = [];
			for( int i = 0; i < 2; i++ ) {
				hqlConstraints << "LOWER(" + columns[ i ] + ") LIKE :search"
			}

			// Group names should be searched separately
			hqlConstraints << "EXISTS ( FROM FeatureGroup fg, FeaturesAndGroups fag WHERE fg = fag.featureGroup AND fag.feature = f AND LOWER(fg.name) LIKE :search)";
			
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
                    redirect(action: "list")
                }
            }
        }
        else {
            if(params?.nextPage=="minimalCreate"){
                render(view: "minimalCreate", model: [featureInstance: featureInstance])
            } else {
                render(view: "create", model: [featureInstance: featureInstance])
            }
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
        session.featureInstance = featureInstance
        if (!featureInstance) {
            flash.message = "The requested feature could not be found."
            redirect(action: "list")
        }
        else {
			// Store session template id, so it will show up correctly after
			// opening the template editor. See also _determineTemplate
			session.templateId = featureInstance.template?.id
			
            return [featureInstance: featureInstance]
        }
    }

    def update = {
        def featureInstance = Feature.get(params.id)
        if (featureInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (featureInstance.version > version) {

                    featureInstance.errors.rejectValue("", "Another user has updated this feature while you were editing. Because of this, your changes have not been saved to the database.")
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

        def return_map = [:]
        return_map = Feature.delete(ids)
        if(return_map["message"]){
            flash.message = return_map["message"]
        }

        if(return_map["action"]){
            redirect(action: return_map["action"])
        } else {
            redirect(action:list)
        }
    }
	
    def confirmNewFeatureGroup = {
        // Used to add a new FeaturesAndGroups connection and to refresh the edit page's feature group list
        if(!session.featureInstance.isAttached()){
            session.featureInstance.attach()
        }
        if(params?.newFeatureGroupID) {
            // Creating a new group
            if( FeaturesAndGroups.create(FeatureGroup.get(params.newFeatureGroupID), session.featureInstance, true ) ) {
			    println "Association created"
            } else {
                println "Association already existed"
            }
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

    // Get a list of template specific fields
    def templateSelection = {
        render(template: "templateSelection", model: [template: _determineTemplate()])
    }
	
	def returnUpdatedTemplateSpecificFields = {
        // Actually using this in a .gsp does not seem to lead to a working template editor
        // TODO: fix this so that add/modify does not have to lead to a page refresh
		def template = _determineTemplate();
		def values = [:];
		
		// Set the correct value of all domain fields and template fields (if template exists) 
		try {
			if( template ) {
				template.fields.each {
					values[it.name] = params.get(it.escapedName());
				}
			}
		} catch( Exception e ) {
			log.error( e );
		}

		render(template: "templateSpecific", model: [template: template, values: values])
    }
	
	/**
	 * Returns the template that should be shown on the screen
	 */
	def _determineTemplate = {
		def template = null;
		
		if( params.templateEditorHasBeenOpened == 'true') {
			// If the template editor has been opened (and closed), we should use
			// the template that we stored previously
			if( session.templateId ) {
				template = Template.get( session.templateId );
			} 
		} else {
			// Otherwise, we should use the template that the user selected.
			if( params.template ) {
				return Template.findByName(params.template)
			}
		}
		
		// Store the template id in session, so the system will know the previously
		// selected template
		session.templateId = template?.id
		
		return template;
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

    /**
     * Returns a list of features as JSON
     * @return	JSON list of features with 'id' and 'name'
     */
	def ajaxList = {
		def features = Feature.list( sort: "name" );
		def lastFeature = Feature.find( "from Feature order by id desc" );
		
		def data = [ "last": [ 'id': lastFeature?.id, 'name': lastFeature?.name ] ,"features": features.collect { return [ 'id': it.id, 'name': it.name ] } ];
        render data as JSON
    }

    def minimalCreate = {
        def featureInstance = new Feature()
        featureInstance.properties = params
        return [featureInstance: featureInstance]
    }

    def minimalShow = {
        [featureInstance: params.featureInstance]
    }

    def importData = {
		redirect( action: 'importDataFlow' )
	}

    def importDataFlow = {

        startUp {
            action{
                flow.pages = [
                    "uploadAndSelectTemplate": "Upload",
                    "matchColumns": "Match Columns",
                    "checkInput": "Check Input",
                    "saveData": "Done"
                ]
            }
            on("success").to "uploadAndSelectTemplate"
        }

        uploadAndSelectTemplate {

            on("next") {
                flow.templateFields = null;
                // Check if the user used the textarea
                if(params.pasteField!=null && params.pasteField!="") {
                    // The textarea is used
                    flow.inputField = params.pasteField;
                } else {
                    // The uploaded files is used
                    flow.inputfile = request.getFile('fileUpload')
                }
            }.to "uploadDataCheck"
        }

        uploadDataCheck {
            // Check to make sure we actually received a file.
            action {

                def text = "";

                // Check if the user used the textarea
                if(flow.inputField!=null && flow.inputField!="") {
                    // Parse the content of the textarea using the Matriximporter
                    text = MatrixImporter.getInstance().importString(flow.inputField,["delimiter":"\t"]);
                } else {
                    // Save the uploaded file into a variable
                    def f = flow.inputfile
                    if(!f.empty) {
                        // Save data of this step
                        flow.message = "It appears this file cannot be read in." // In case we get an error before finishing
                        try{
                            // Make the tempfolder (if it doesn't excist)
                            new File( "./tempfolder/" ).mkdirs()
                            // Transfer the file to the tempfolder
                            f.transferTo( new File( "./tempfolder/" + File.separatorChar + f.getOriginalFilename() ) )
                            // Get a variable for the transfered file and save it in the flow
                            File file = new File("./tempfolder/" + File.separatorChar + f.getOriginalFilename())
                            flow.inputfile = file
                            // Get the content of the transfered file
                            text = MatrixImporter.getInstance().importFile(file);
                        } catch(Exception e){
                            // Something went wrong with the file...
                            flow.message += " The precise error is as follows: "+e
                            return error()
                        }

                        // Check if the uploaded file had any content
                        if(text==null){
                            // Apparently the MatrixImporter was unable to read this file
                            flow.message += ' Make sure to add a comma-separated values based or Excel based file using the upload field below.'
                            return error()
                        }
                        // Save some variables of the file into the flow
                        flow.input = [ "file": flow.inputfile, "originalFilename": f.getOriginalFilename()]
                    } else {
                        flow.message += ' Make sure to add a file using the upload field below. The file upload field cannot be empty.'
                        return error()
                    }
                }

                // If we've reached this point, the error message needs to be reset
                flow.message = null;

                // Store the domainfields in the flow
                flow.templateFields = Feature.giveDomainFields()

                // Store the selected template in the flow
                flow.template = params.template;

                // If a template is selected, store the templatefields in the flow
                if(flow.template!="") {
                    // Refresh the template because a user can have edited it
                    Template objTempl = Template.findByName(params.template).refresh();

                    flow.templateFields += objTempl.fields;
                }

                // Compute fuzzy matching
                def fuzzyMatchTreshold = 0.0;
                flow.columnField = [:];
                def lstFieldNames =  [];
                for(int k=0; k<flow.templateFields.size(); k++) {
                    lstFieldNames += flow.templateFields[k].name.toLowerCase();
                }
                def lstColumnHeaders = [];
                for(int j=0; j<text[0].size(); j++) {
                    lstColumnHeaders += text[0][j].toLowerCase();
                }

                def matches = fuzzySearchService.mostSimilarUnique( lstColumnHeaders, lstFieldNames, fuzzyMatchTreshold );

                for(int i=0; i<text[0].size(); i++) {
                    if(matches[i].index!=null) {
                        flow.columnField.put(i,flow.templateFields[matches[i].index]);
                    }
                }

                // Store the content of the textarea or the file in the flow
                flow.text = text;
            }
            on("success").to "matchColumns"
            on("error").to "uploadAndSelectTemplate"
        }

        matchColumns {
            on("next") {
                flow.message = null;
                String newMessage = "";

                // Get the rows that need to be discarded
                flow.discardRow = [];
                flow.featureList = [];
                for(int i=1; i<flow.text.size(); i++) {
                    if(!params.get("row_"+i)) {
                        flow.discardRow.add(i);
                    } else {
                        Feature objFeature = new Feature();
                        if(flow.template!="")
                            objFeature.changeTemplate(flow.template);

                        for(int j=0; j<flow.text[0].size(); j++) {

                            if(params.get("column_"+j)!="") {
                                try {
                                    objFeature.setFieldValue(params.get("column_"+j),flow.text[i][j],true);
                                } catch (Exception e) {
                                    if(newMessage.length()>0) newMessage += "<br />";
                                    newMessage += "Row "+i+", column ["+params.get("column_"+j)+"] can't be set to ["+flow.text[i][j]+"]";
                                }
                            }
                        }

                        objFeature.validate();
                        objFeature.getErrors().allErrors.each {
                            if(newMessage.length()>0) newMessage += "<br />";
                            switch(it.code) {
                                case "unique":
                                    newMessage += "A feature with the name ["+it.rejectedValue+"] already exists.";
                                    break;
                                case "nullable":
                                    newMessage += "The field ["+it.field+"] can't be null.";
                                    break;
                                default:
                                    newMessage += "Errorcode ["+it.code+"] on field ["+it.field+"] with value ["+it.rejectedValue+"]";
                            }
                        }

                        if(newMessage.length()>0) flow.message = newMessage;
                        flow.featureList.add(objFeature);
                    }
                }

                // Get the columns that need to be discarded
                flow.discardColumn = [];
                flow.columnField = [:];
                for(int j=0; j<flow.text[0].size(); j++) {
                    if(params.get("column_"+j)=="") {
                        flow.discardColumn.add(j);
                    } else {
                        for(int i=0; i<flow.templateFields.size(); i++) {
                            if(flow.templateFields[i].name==params.get("column_"+j)) {
                                flow.columnField.put(j,flow.templateFields[i]);
                                break;
                            }
                        }
                    }
                }

            }.to "checkInput"
            on("previous") {
              flow.message = null;
            }.to "uploadAndSelectTemplate"

        }

        checkInput {
            on("save") {
                //flow.inputfile = request.getFile('fileUpload')
            }.to "saveData"
            on("previous"){
                flow.message = null;
            }.to "matchColumns"
        }

        saveData {
            action {
                flow.message = null;
                String newMessage = "";
                def newFeatureList = [];

                for(int i=0; i<flow.featureList.size; i++) {

                    Feature objFeature = flow.featureList[i];
                    String strIdent = objFeature.getIdentifier();

                    // Set all variables from POST var
                    for(int j=0; j<flow.templateFields.size(); j++) {
                        String strFieldVal = params.get("entity_"+strIdent+"_"+flow.templateFields[j].name.toLowerCase());
                        if(flow.templateFields[j].required && strFieldVal==null) {
                            if(newMessage.length()>0) newMessage += "<br />";
                            newMessage += "Column ["+flow.templateFields[j]+"] is required";
                        } else {
                            try {
                                objFeature.setFieldValue(flow.templateFields[j].name,strFieldVal,true)
                                //println("\n\n["+flow.templateFields[j].name+"] set to ["+strFieldVal+"]\n\n");
                            } catch (Exception e) {
                                if(newMessage.length()>0) newMessage += "<br />";
                                newMessage += "Column ["+flow.templateFields[j]+"] can't be set to ["+strFieldVal+"]";
                            }
                        }
                    }

                    objFeature.validate();
                    objFeature.getErrors().allErrors.each {
                        if(newMessage.length()>0) newMessage += "<br />";
                        switch(it.code) {
                            case "unique":
                                newMessage += "A feature with the name ["+it.rejectedValue+"] already excists.";
                                break;
                            case "nullable":
                                newMessage += "The field ["+it.field+"] can't be null.";
                                break;
                            default:
                                newMessage += "Errorcode ["+it.code+"] on field ["+it.field+"] with value ["+it.rejectedValue+"]";
                        }
                    }

                    newFeatureList.add(objFeature);
                }

                if(newMessage.length()>0) {
                    flow.featureList = newFeatureList;
                    flow.message = newMessage;
                    return error();
                } else {
                    // SAVE DATA
                    for(int i=0; i<newFeatureList.size(); i++) {
                        Feature objFeature = newFeatureList[i];
                        objFeature.save();
                    }
                }
            }
            on("success").to "finishScreen"
			on("error").to "errorSaving"
		}

        errorSaving {
			on("previous"){
                flow.message = null;
            }.to "checkInput"
		}

        finishScreen()
    }

}