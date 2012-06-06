package org.dbxp.sam

import org.dbxp.matriximporter.MatrixImporter
import org.dbxp.moduleBase.Assay
import org.dbxp.moduleBase.Auth
import org.dbxp.moduleBase.Sample
import org.dbnp.gdt.RelTime
import org.codehaus.groovy.grails.commons.ConfigurationHolder

class MeasurementController {
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def fuzzySearchService
	
	def sessionFactory
	def propertyInstanceMap = org.codehaus.groovy.grails.plugins.DomainClassGrailsPlugin.PROPERTY_INSTANCE_MAP
	
    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
		// Find all measurements this user has access to 
		def measurements = Measurement.giveReadableMeasurements( session.user );
		
        [measurementInstanceList: measurements, measurementInstanceTotal: measurements.size() ]
    }

    def create = {
		// If no samples are present, we can't add measurements
	    def features = Feature.list();
	    def samples = SAMSample.giveWritableSamples( session.user )

	    if( samples.count() == 0 ) {
			redirect(action: 'noassays')
		}
		
        def measurementInstance = new Measurement()
        measurementInstance.properties = params

        return [measurementInstance: measurementInstance, samples: samples, features: features]
    }

    def save = {
        def measurementInstance = Measurement.findByFeatureAndSample(Feature.get(params.feature.id), Sample.get(params.sample.id))
        if(measurementInstance!=null){
            bindData(measurementInstance, params)
        } else {
            measurementInstance = new Measurement( params )
        }
		
		// Unfortunately, grails is unable to handle double values correctly. If
		// one enters 10.20, the value of 1020.0 is stored in the database. For that
		// reason, we convert the value ourselves
		if( params.value?.isDouble() )
			measurementInstance.value = params.value as Double

        if (measurementInstance.save(flush: true)) {
            flash.message = "The measurement has been created."
            redirect(action: "show", id: measurementInstance.id)
        }
        else {
			def features = Feature.list();
			def samples = SAMSample.giveWritableSamples( session.user )
	
            render(view: "create", model: [measurementInstance: measurementInstance, samples: samples, features: features])
        }
    }

    def show = {
        def measurementInstance = Measurement.get(params.id)
        if (!measurementInstance) {
            flash.message = "The requested measurement could not be found."
            redirect(action: "list")
        } else if( !measurementInstance.sample.assay.study.canRead( session.user ) ) {
			flash.message = "You are not allowed to access the requested measurement."
			redirect( action: "list" );
        } else {
            [measurementInstance: measurementInstance]
        }
    }

    def edit = {
        def measurementInstance = Measurement.get(params.id)
        if (!measurementInstance) {
            flash.message = "The requested measurement could not be found."
            redirect(action: "list")
        }
        else {
            return [measurementInstance: measurementInstance]
        }
    }

    def update = {
        def measurementInstance = Measurement.get(params.id)
        if (measurementInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (measurementInstance.version > version) {

                    measurementInstance.errors.rejectValue("Another user has updated this feature while you were editing. Because of this, your changes have not been saved to the database.")
                    render(view: "edit", model: [measurementInstance: measurementInstance])
                    return
                }
            }
            measurementInstance.properties = params
			
			// Unfortunately, grails is unable to handle double values correctly. If
			// one enters 10.20, the value of 1020.0 is stored in the database. For that
			// reason, we convert the value ourselves
			if( params.value?.isDouble() )
				measurementInstance.value = params.value as Double
			
            if (!measurementInstance.hasErrors() && measurementInstance.save(flush: true)) {
                flash.message = "The measurement has been updated."
                redirect(action: "show", id: measurementInstance.id)
            }
            else {
                render(view: "edit", model: [measurementInstance: measurementInstance])
            }
        }
        else {
            flash.message = "The requested measurement could not be found."
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
			def measurementInstance = Measurement.get(id)
	        if (measurementInstance) {
                try {
					measurementInstance.delete(flush: true)
					numDeleted++;
	            } catch (org.springframework.dao.DataIntegrityViolationException e) {
	                log.error(e)
					numErrors++;
	            }
	        }
	        else {
				numNotFound++;
	        }
		}
		
		if( numDeleted == 1  )
			flash.message = "1 measurement has been deleted from the database"
		if( numDeleted > 1 )
			flash.message = numDeleted + " measurements have been deleted from the database"
		
		flash.error = ""
		if( numNotFound == 1 )
			flash.error += "1 measurement has been deleted before." 
		if( numNotFound > 1 )
			flash.error += numNotFound+ " measurements have been deleted before." 

		if( numErrors == 1 )
			flash.error += "1 measurement could not be deleted. Please try again" 
		if( numErrors > 1 )
			flash.error += numErrors + " measurements could not be deleted. Please try again" 
		
		// Redirect to the assay list, because that is the only place where a 
		// delete button exists.
		if( params.assayId ) {
			redirect( controller: "assay", action: "show", id: params.assayId )
		} else {
			redirect(action: "list")
		}
    }

	void checkForFeatures() {

	}

    def nofeatures = {
	    flash.message = "There are no features defined. Without features, you can't add measurements."
	    redirect( controller: 'feature', action: 'list' );
    }

	def noassays = {
		flash.message = "You have no assays that you are allowed to edit. Without writable samples, you can't add measurements."
		redirect( controller: 'assay', action: 'list' );
	}
    
	def importData = {
		// If no samples are present, we can't add measurements
		if( Sample.count() == 0 ) {
			flash.message = "No samples have been created in GSCF yet. Without samples, you can't import measurements."
			redirect( controller: 'assay', action: 'list' );
		}
		
		redirect( action: 'importDataFlow' )
	}

	def importDataFlow = {

        startUp {
            action{
				// First synchronize all studies that have been changed
				try {
					synchronizationService.initSynchronization( session.sessionToken, session.user );
					synchronizationService.synchronizeChangedStudies()
				} catch( Exception e ) {
					// If an exception occurs, probably the synchronization is already running. Notify the user,
					// but still continue
					flash.error = "Synchronization with GSCF failed: " + e.getMessage();
				}

                if(Feature.count() == 0){
                    redirect(action: 'nofeatures')
                }

	            // TODO: Maybe we want to make this search functionality available in, for example, Assay.groovy
	            // Grabs the Ids of assays that contain samples and the user can write to
	            def assayIdList = Assay.executeQuery( "SELECT DISTINCT a.id FROM Assay a, Auth auth LEFT JOIN  a.samples s WHERE ( auth.user = :user AND auth.study = a.study AND auth.canWrite = true) GROUP BY a HAVING COUNT(s) > 0", [ "user": session.user ] )

	            if( assayIdList.empty ) {
		            redirect(action: 'noassays')
	            }

	            flow.assayList = Assay.executeQuery( "SELECT DISTINCT a FROM Assay a WHERE  a.id in (:list)", [ "list": assayIdList ])

                flow.pages = [
                    "chooseAssay": "Choose Assay",
                    "uploadData": "Upload",
                    "selectLayout": "Select Layout",
                    "selectColumns": "Select Columns",
                    "saveData": "Done"
                ]
            }
            on("success").to "chooseAssay"
        }

		chooseAssay {
			// Step 1: choose study and assay (update assay dropdown based on the study selected)
			on("next") {
                flow.assay = Assay.get(params.assay)
                flow.studyName = flow.assay.study.name

                // Reset the relevant data that might have been entered by the user before, in the next step(s) of the wizard
                flow.inputField = null;
                flow.inputFile = null;
                flow.pasteField = null;
                flow.text = null;
                flow.edited_text = null;
                flow.timepoint_matches = null;
                flow.timepoints = null;
                flow.sample_matches = null;
                flow.samples = null;
                flow.feature_matches = null;
                flow.features = null;
                flow.comments = null;
                flow.operator = null;
			}.to "uploadData"
		}

		uploadData {
			// Step 2: upload data and give the user a preview. The user then chooses which layout he wants
			// to use.
			on("next") {
                if(params.pasteField!=null && params.pasteField!="") {
                    flow.inputField = params.pasteField;
                } else {
                    flow.inputfile = request.getFile('fileUpload')
                }

                // Clear upload screen error message by hand
                flow.message = null;
			}.to "uploadDataCheck"
			on("previous"){
                // Clear upload screen error message by hand
                flow.message = null;
            }.to "chooseAssay"
		}

        uploadDataCheck {
            // Check to make sure we actually received a file.
            action {
                def f = flow.remove( 'inputfile' );
                def filename = ""
                def text = ""
				
				// Reset all data that might have been entered by the user before, in other 
				// steps of the wizard. This data might interfere with the new file the user entered 
				flow.edited_text = null
				flow.operator = null
				flow.comments = null

                if(flow.inputField!=null) {
                    text = MatrixImporter.getInstance().importString(flow.inputField,["delimiter":"\t"]);
                    flow.text = text
                    flow.layoutguess = "sample_layout";
                } else {
                    if(!f.empty) {
                        // Save data of this step
                        try{
                            text = MatrixImporter.getInstance().importInputStream(f.getInputStream(),[:],false,false);
                        } catch(Exception e){
                            // Something went wrong with the file...
                            flow.message = "It appears this file cannot be read in. The precise error is as follows: "+e
                            return error()
                        }
                    }
                    else {
                        flow.message = 'Make sure to add a file using the upload field below or use the \'paste in textfield\' option to upload the data.'
                        return error()
                    }
                }

                // What did the MatrixImporter return?
                if(text==null){
                    // Apparently the MatrixImporter was unable to read this file
                    flow.message = "It appears this file cannot be read in. Make sure to add a comma-separated values based or Excel based file using the upload field below."
                    return error()
                }
                if(text.size()<2 || text[0].size()<2){
                    flow.message = "It appears the data does not have a valid layout. Please refer to the layout examples."
                    return error()
                }

                // Before doing all the layout detection calculations, check if subject_layout is even possible
                def tmp1 = flow.assay.samples.eventStartTime.unique()
                def tmp2 = flow.assay.samples.subjectName.unique()
                if(tmp1.size()==0 || tmp1.contains(null) ||  tmp2.size()==0 || tmp2.contains(null)){
                    // No start times? No subject names? Cannot select subject layout then!
                    flow.disableSubjectLayout = true
                    flow.layoutguess = 'sample_layout'
                } else {
                    flow.disableSubjectLayout = false;
                    // Start layout detection calculations

                    // In the following section we will try to find out what layout the data in this file has
                    def sampl = 0
                    def subj = 0

                    if(text[1][0]==null || text[1][0]==""){
                        // Cell A2 empty? That would indicate subject layout.
                        // It is also a pretty good sign that this is not a sample layout
                        subj++
                        sampl--
                    } else {
                        // If cell A2 is not empty, it supports a conclusion of sample layout,
                        // but it does not substract from a subject layout conclusion (there might be a comment there)
                        sampl++
                    }

                    // If the second row contains only doubles, this makes it more likely to be a sample layout
                    def double_rainbow = true
                    for(int i = 1; i < text[1].size(); i++){
                        if(i == 15){
                            // Don't check everything
                            break;
                        }
                        if(!text[1][i].isDouble()){
                            double_rainbow = false
                        }
                    }
                    if(double_rainbow){
                        sampl++
                    }

                    // If the first row contains different features, this makes it more likely to be a sample layout
                    // The opposite situation is also true
                    def tmp = []
                    for(int i = 1; i < text[0].size(); i++){
                        if(i == 15){
                            // Don't check everything
                            break;
                        }
                        tmp.push(!text[0][i])
                    }
                    if(tmp.size()==tmp.unique().size()){
                        sampl++
                    } else {
                        subj++
                    }

                    // Take a guess at the layout
                    def guess = "sample_layout"
                    if(subj>sampl) guess = "subject_layout"
                    flow.layoutguess = guess
                }

                flow.text = text
                //flow.input = [ "file": flow.inputfile ]
            }
            on("success").to "selectLayout"
            on("error").to "uploadData"
        }

        selectLayout {
            // Step x: Choose layout, preview data
			on("next") {

				// We first check whether the user has selected a layout before. If he has, he might also have 
				// matched columns etc. If he selects the same layout, we keep his changes. Otherwise, these changes 
				// are removed again
				if( flow.layout && flow.layout != params.layoutselector ) {
					flow.edited_text = null
					flow.operator = null
					flow.comments = null
				}
				
				// Save data of this step
                flow.layout = params.layoutselector
				flow.features = Feature.list( sort: "name" )

                if(params.layoutselector=="sample_layout"){
                    flow.samples = Sample.findAllByAssay( flow.assay, [ sort: "name" ] )

                    // Try to match first row to features
                    flow.feature_matches = [:]
					
					def results = fuzzySearchService.mostSimilarUnique( flow.text[0]*.toString()*.trim(), flow.features*.toString(), ['controller': 'measurementImporter', 'item': 'feature'] )
					
                    for(int i = 1; i < flow.text[0].size(); i++){
						def index = results.find { it.pattern == flow.text[0][i].toString().trim() }?.index
                        flow.feature_matches[flow.text[0][i]] = index
                    }
                    // Try to match first column to samples
                    flow.sample_matches = [:]
                    def lstColumnHeaders = [];
                    for(int i = 1; i < flow.text.size(); i++){
                        lstColumnHeaders << flow.text[i][0].toString().trim()
                    }

                    results = fuzzySearchService.mostSimilarUnique( lstColumnHeaders, flow.samples.name, ['controller': 'measurementImporter', 'item': 'sample'] )
                    for(int i = 0; i < lstColumnHeaders.size(); i++){
                        def index = results.find { it.pattern == lstColumnHeaders[i].toString().trim() }?.index
                        flow.sample_matches[lstColumnHeaders[i].toString().trim()] = index
                    }
                } else {
                    def samples = flow.assay.samples
                    
					// Retrieve timepoints and convert them to RelTime strings
					flow.timepoints = samples*.eventStartTime.unique()
					flow.timepoints.sort();
					flow.timepoints = flow.timepoints.collect { new RelTime( it ).toString() }
                    
					// TODO: retrieve the sorted subjects directly from the database for performance reasons
					flow.subjects = samples*.subjectName.unique().sort()

                    // Try to match first row to features
                    flow.feature_matches = [:]
                    for(int i = 1; i < flow.text[0].size(); i++){
                        def index = fuzzySearchService.mostSimilarWithIndex(flow.text[0][i].toString().trim(), flow.features*.toString(), ['controller': 'measurementImporter', 'item': 'feature'])
                        flow.feature_matches[flow.text[0][i]] = index
                    }
                    // Try to match second row to timepoints
                    flow.timepoint_matches = [:]
                    for(int i = 1; i < flow.text[1].size(); i++){
                        def index = fuzzySearchService.mostSimilarWithIndex(flow.text[1][i].toString().trim(), flow.timepoints, ['controller': 'measurementImporter', 'item': 'timepoint'])
                        flow.timepoint_matches[flow.text[1][i]] = index
                    }
                    // Try to match first column to subjects
                    flow.subject_matches = [:]
                    def lstColumnHeaders = [];
                    for(int i = 2; i < flow.text.size(); i++){
                        lstColumnHeaders << flow.text[i][0].toString().trim()
                    }

                    def results = fuzzySearchService.mostSimilarUnique( lstColumnHeaders, flow.subjects, ['controller': 'measurementImporter', 'item': 'subject'] )
                    for(int i = 0; i < lstColumnHeaders.size(); i++){
                        def index = results.find { it.pattern == lstColumnHeaders[i].toString().trim() }?.index
                        flow.subject_matches[lstColumnHeaders[i].toString().trim()] = index
                    }
                }
			}.to "selectColumns"
			on("previous") {
                // Reset the relevant data that might have been entered by the user before, in the previous and current step of the wizard
                flow.inputField = null;
                flow.inputFile = null;
                flow.pasteField = null;
                flow.text = null;
                flow.edited_text = null;
                flow.timepoint_matches = null;
                flow.timepoints = null;
                flow.sample_matches = null;
                flow.samples = null;
                flow.feature_matches = null;
                flow.features = null;
                flow.comments = null;
                flow.operator = null;
            }.to "uploadData"
        }

        selectColumns {
			// Step 3: Choose which features in the database match which column in the uploaded file
			on("next") {
				// Save data of this step and make some more information available about the contents of the cells

                // Generate extra information about cell contents and fold the user's selections into our data storage object flow.edited_text
                def fresh // Is this a 'fresh start'?
                def subjectTimepointConflicts = [] // Can that subject be combined with that timepoint?
                flow.ignore = [] // Add datapoints that will be ignored to this array
                if(!flow.edited_text){
                    flow.edited_text = new Object[flow.text.size()][flow.text[0].size()]
                    fresh = true;
                }
                if(!flow.operator){
                    flow.operator = [:]
                }
                if(!flow.comments){
                    flow.comments = [:]
                }
				
                for(int i = 0; i < flow.text.size(); i++){
                    for(int j = 0; j < flow.text[i].size(); j++){
                        if(flow.text[i][j]!=null) flow.text[i][j] = flow.text[i][j].trim() // Taking this opportunity to trim cells. This way extraneous whitespace will not show up as comments.
                        if(params[i+','+j]){
                            // Here we are catching a user's feature, timepoint or sample selection from the previous page and incorporating it into our new dataset

                            // We receive an object's id and use this to add the object to the flow.edited_text
                            if(params[i+','+j] == 'null'){
                                // We didn't actually receive a proper id, so set the field to null
                                flow.edited_text[i][j] = null
                                continue;
                            }
                            if(i==0){
                                flow.edited_text[i][j] = Feature.findById(params[i+','+j])
                                continue;
                            }


                            if(flow.layout=="sample_layout"){
                                if(j==0){
                                    flow.edited_text[i][j] = SAMSample.findById(params[i+','+j])
                                    continue;
                                }
                            } else {
                                if(i==1 || j==0){
                                    flow.edited_text[i][j] = params[i+','+j]
                                    def subjectTimepointConflictsResult = checkForSubjectTimepointConflict(i, j, subjectTimepointConflicts, flow.assay, flow.ignore, flow.text)
                                    subjectTimepointConflicts = subjectTimepointConflictsResult['subjectTimepointConflicts']
                                    flow.ignore = subjectTimepointConflictsResult['ignore']
                                    continue;
                                }
                            }
                        } else {
                            if(fresh){
                                def flowObjects = buildCheckInputFlowObjects(i, j, flow.text, flow.edited_text, flow.operator, flow.comments)
                                flow.edited_text = flowObjects['edited_text']
                                flow.operator = flowObjects['operator']
                                flow.comments = flowObjects['comments']
                            }
                        }
						
                    } 
                }

                // Check if the user is even importing any data at all. If not, return error message.
                def countRows = 0
                def countColumns = 0
                for(int i = 0; i < flow.text.size(); i++){
                    for(int j = 0; j < flow.text[i].size(); j++){
                        if(params[i+','+j]){
                            // Did the user set enough rows/columns to be included in the importing process?
                            if(params[i+','+j] == 'null'){
                                // Not included...
                                continue;
                            }
                            if(i==0){
                                countColumns++;
                                continue;
                            }
                            if(j==0){
                                countRows++
                                continue;
                            }
                            if(countColumns>0&&countRows>0){
                                // It seems that at least some data is set to be imported, so carry on.
                                break;
                            }
                        }
                    }
                }
				
                // Not a single row or not a single column that isn't set on discard?
                // That is probably a user error.
                if(countRows<1 || countColumns<1){
                    flash.message = "With the selection that had been made, no data would be uploaded. Please make a different selection."
					return error();
                }

                // Check to see if features and timepoint combinations occur more than once (which is not allowed)
                if(flow.layout=='subject_layout') {
                    def featureTimepointDuplicates = checkForFeatureTimepointDuplicates(flow.edited_text[0], flow.edited_text[1])
                    if(featureTimepointDuplicates?.size()>0){
                        flash.featureTimepointDuplicatesMessage="Unfortunately, the iput data contains multiple entries for the following features and timepoints: "
                        featureTimepointDuplicates.each {
                            flash.featureTimepointDuplicatesMessage+="<br/> - "+it.key.toString()+" and "+it.value.toString()
                        }
                        flash.featureTimepointDuplicatesMessage+="<br/>Please make a different selection."
                        // This can not be ignored! Return error.
                        return error();
                    }
                }
                
                // Did we have subject/timepoint conflicts?
                if(subjectTimepointConflicts!=null && subjectTimepointConflicts.size()>0){
                    flash.subjectTimepointConflictsMessage="Unfortunately, according to the study the following subject names and timepoints cannot be combined: "
                    subjectTimepointConflicts.each {
                        flash.subjectTimepointConflictsMessage+="<br/> - "+it['timepoint']+" and "+it['subjectName']
                    }
                    flash.subjectTimepointConflictsMessage+="<br/>Please make a different selection or indicate that you wish to ignore the conflicting datapoints. These datapoints will not be imported. Alternatively, you can edit your study in GSCF and restart the importer."
                    if(!params.ignoreConflictedData){
                        // User did not ask to ignore this, so don't let user proceed
                        return error();
                    }
                }
			}.to "saveData"
			on("previous") {
				// Save data of this step
                // This is done to be able to redo matching when going back to, for example, the selectLayout step
                if(!flow.edited_text){
                    flow.edited_text = new Object[flow.text.size()][flow.text[0].size()]
                }
                
                // Fold the user's selections into our flow.feature_matches and flow.sample_matches
                for(int i = 0; i < flow.text.size(); i++){
                    for(int j = 0; j < flow.text[i].size(); j++){
                        if(params[i+','+j]){
                            // Here we are catching a user's feature or sample selection from the previous page and incorporating it into our new dataset
                            // We receive an object's id and use this to the object to the flow.edited_text

                            if(params[i+','+j] == 'null'){
                                // We didn't actually receive a proper id, so set the field to null
                                flow.edited_text[i][j] = null
                                continue;
                            }
                            if(i==0){
                                flow.edited_text[i][j] = Feature.findById(params[i+','+j])
                                continue;
                            }
                            if(flow.layout=="sample_layout"){
                                if(j==0){
                                    flow.edited_text[i][j] = SAMSample.findById(params[i+','+j])
                                    continue;
                                }
                            } else {
                                if(i==1 || j==0){
                                    flow.edited_text[i][j] = params[i+','+j]
                                    continue;
                                }
                            }
                        }
                    }
                }
                // Update feature list in case the user has created new features on 'selectColumns.gsp'
                flow.features = Feature.list().sort(){it.name}
			}.to "selectLayout"
			on("error").to "selectColumns"
		}

		saveData {
			action {
				// Save data into the database
                flash.message = ""

				def t = System.currentTimeMillis();
				
                def measurementList = []
				// Update feature list in case the user has created new features on their previous visit to the selectColumns page
				flow.features = Feature.list().sort(){it.name}

				if(flow.layout=="sample_layout"){
                    for(int i = 1; i < flow.edited_text.size(); i++){
                        // For a particular sample
                        if(flow.edited_text[i][0]!=null && flow.edited_text[i][0]!="null"){
                            SAMSample s = flow.edited_text[i][0]
                            for(int j = 1; j < flow.edited_text[0].size(); j++){
                                // ... and a particular feature
                                if(flow.edited_text[0][j]!=null && flow.edited_text[0][j]!="null"){
                                    Feature f = flow.edited_text[0][j]
                                    // ... a measurement will be created
	                                if (flow.edited_text[i][j] != null) {
		                                measurementList.add(importerCreateMeasurement(s, f, flow.edited_text[i][j], null, null))
	                                }
                                }
                            }
                        }
                    }
                } else {
					def assaySamples = flow.assay.samples;
				
                    for(int i = 1; i < flow.edited_text.size(); i++){
                        if(flow.edited_text[i][0]!=null && flow.edited_text[i][0]!="null"){
                            for(int j = 1; j < flow.edited_text[0].size(); j++){
                                if(i>1 && flow.edited_text[0][j]!=null && flow.edited_text[0][j]!="null" && flow.edited_text[1][j]!=null && flow.edited_text[1][j]!="null"){
                                    // For a particular subject and a particular timepoint and thus a particular sample
									
									// In order for that to work, reconvert the timepoint into seconds
									def timepoint = new RelTime( flow.edited_text[1][j] ).getValue();
									
                                    SAMSample s = assaySamples.find { it.eventStartTime == timepoint && it.subjectName == flow.edited_text[i][0] }

                                    if(s==null){
                                        // This datapoint needs to be ignored on account of a subject/timepoint conflict; adding a datapoint for this particular eventStartTime and subjectName combination is simply not allowed.
                                        continue;
                                    }
                                    // ... and a particular feature
                                    Feature f = flow.edited_text[0][j]
									
                                    // ... a measurement will be created
	                                if (flow.edited_text[i][j] != null) {
		                                measurementList.add(importerCreateMeasurement(s, f, flow.edited_text[i][j], null, null))
	                                }
                                }
                            }
                        }
                    }
                }
				
				log.trace "Creating list of samples (looking up samples): " + ( System.currentTimeMillis() - t )
				t = System.currentTimeMillis();
				
				// Check whether the assay is still writable
				if( !flow.assay.study.canWrite( session.user ) ) {
					flash.message = "The authorization of your study has changed while you were adding measurements. Please choose another assay."
					return error();
				}
				
				// First create a list of measurements to save. This is done to avoid
				// database lookups within the transaction to speed it up
				def measurementsToSave = [];
				measurementList.each {
					m ->
					if( m ) {
						def measurementInstance = Measurement.findByFeatureAndSample( m.feature, m.sample );
						
						if(measurementInstance!=null){
							measurementInstance.value = m.value
							measurementInstance.operator = m.operator
							measurementInstance.comments = m.comments
							
							measurementsToSave << measurementInstance
						} else {
							measurementsToSave << m
						}
					}
				}
				
				log.trace "Looking up existing measurements: " + ( System.currentTimeMillis() - t )
				t = System.currentTimeMillis();
				
                Measurement.withTransaction {
                    status ->
					def i = 0;
                    measurementsToSave.each {
                        m ->
						if( m && !status.isRollbackOnly() ) {
							try {
	                            if(!m.save(flush : true)){
	                                flash.message += "<br>"+m.getErrors().allErrors
	                                println m.getErrors().allErrors
	                                status.setRollbackOnly();
	                            }
							} catch( Exception e ) {
								flash.message += "<br>" + e.getMessage();
								e.printStackTrace();
								status.setRollbackOnly();
							}
							
							// Clear hibernate session, in order to handle large amounts of
							// samples
							if (i++ % 20 == 0) cleanUpGorm( m )
						}
                    }
                }
				
				log.trace "Time it took for saving: " + ( System.currentTimeMillis() - t );
				
                if(flash.message!=""){
                    flash.message = "There were errors while saving your measurements: "+flash.message
                    return error()
                } else {
                    flash.remove('message');
                }
			}
			on("success").to "finishScreen"
			on("error").to "errorSaving"
		}

        errorSaving {
			on("previous").to "selectColumns"
		}

        finishScreen ()
	}

	/**
	 * When saving lots of measurements, the hibernate session must be cleaned, otherwise
	 * the import will be very very slow. See http://naleid.com/blog/2009/10/01/batch-import-performance-with-grails-and-mysql/
	 * for more information.
	 * @return
	 */
	def cleanUpGorm( Measurement m ) {
		//log.trace( "Cleaning measurement from hibernate cache" );
		//sessionFactory.evict(Measurement.class, m.id); //
		
		log.trace( "Cleaning hibernate session while saving" );
		def session = sessionFactory.currentSession
		session.flush()
		session.clear()
		propertyInstanceMap.get().clear()
	}		

    Measurement importerCreateMeasurement(SAMSample s, Feature f, def txt, def comm, def op) {
        def operator
        def comments
        def val

	    // If there is no value, don't save the measurement
	    // TODO: check if there is a case where comments can be entered on an empty measurement
	    if (txt == null) {
		    return null
	    }

        // Check if the measurement value has an operator or is a comment
        if(!txt.isDouble()){
            // Apparently the value is not a valid double

            // Do we have enough characters for an operator and a number? Is the first character a valid operator?
            if(txt.length()>1 && Measurement.validOperators.contains(txt.substring(0,1)) && txt.substring(1).trim().isDouble()){
                // Apparently, it is.
                operator = txt.substring(0,1).trim()
                val = Double.valueOf(txt.substring(1).trim())
            } else {
                // Apparently it is not.
                // We'll use the comments field instead.
                comments = txt
            }
        } else {
            // This is a simple double value
            val = Double.valueOf(txt)
        }

        // If comments were added to the webflow...
        if(comm!=null && comm!=comments){
            // If the comments added in the webflow are different from the cell contents, these will probably be comments on the cell contents, so set them
            // If we already have comments, add the webflow comments to the end
            if(comments==null){
                comments = comm
            } else {
                comments += " "+comm
            }
        }

        // If an operator was added in the webflow...
        if(op!=null){
            // If an operator was added to webflow, the user explicitly did that, so add the operator from the webflow
            // If an invalid operator was added, add that operator to the comments instead
            if(Measurement.validOperators.contains(op)){
                operator = op
            } else {
                comments = "Operator: "+op+". "+comments
            }
        }

		// A measurement needs a value or a comments field
		if( val != null || comments ) 
        	return new Measurement(sample:s,feature:f,value:val,operator:operator,comments:comments)
		else
			return null
    }
	
	/**
	 * Deletes all measurements from the given assay
	 */
	def deleteByAssay = {
		def assayId = params.id
		
		if( !assayId || !assayId.isLong() ) {
			flash.error = "No assay selected"
			redirect( controller: "assay", view: "list" );
			return;
		}
		
		def assay = Assay.get( assayId.toLong() );
		
		if( !assay ) {
			flash.error = "Incorrect assay Id given"
			redirect( controller: "assay", view: "list" );
			return;
		}
		
		if( Measurement.deleteByAssay( assay ) ) {
			flash.message = "Your measurements for assay " + assay + " have been deleted."
		} else {
			flash.error = "An error occurred while deleting measurements for this assay. Please try again or contact your system administrator."
		}
		
		redirect( controller: "assay", view: "list" );
	}

    def checkForFeatureTimepointDuplicates(features, timepoints) {
        def featureTimepointDuplicates = [:] // This list will hold information about the combinations that occurs more than once - something that is not allowed
        def featureTimepointList = [] // List of combinations that have already been seen. If one encounters a combination that already exists in this list, one knows one has found a duplicate
        features.eachWithIndex {f, fi ->
            if(f!=null){
                if(featureTimepointList.contains(f.toString()+"@SEP@"+timepoints[fi])){
                    featureTimepointDuplicates.put(f, timepoints[fi])
                } else {
                    featureTimepointList.add(f.toString()+"@SEP@"+timepoints[fi])
                }
            }
        }
        println "featureTimepointDuplicates"
        featureTimepointDuplicates.each {
            println it.key.toString()+", "+it.value.toString()
        }
        return featureTimepointDuplicates
    }

    def checkForSubjectTimepointConflict(int i, int j, subjectTimepointConflicts, assay, ignore, text) {
        // Check for a subject/timepoint conflict, for those timepoints that are not discarded (also check their features to make sure those are not discarded either)
        // Empty cells should always be ignored.
        if(i==1 && j!= 0 && params[1+','+j]!='null' && params[0+','+j]!='null'){
            // Build a list of eventStartTimes and subjects, in order to lookup
            // conflicts fast. The map has the keys being the eventStartTimes and
            // every value is a list on its own of sample names belonging to that startTime
            def validCombinations = [:]
            assay.samples.each {
                def startTime = new RelTime( it.eventStartTime ).toString();
                def subjectName = it.subjectName;

                if( !validCombinations[ startTime ] )
                    validCombinations[ startTime ] = [ subjectName ]
                else
                    validCombinations[ startTime ] << subjectName
            }

            for(int k = 1; k < text.size(); k++){
                boolean blnNoDataInCell = false
                if(text[k][j]==null || text[k][j].toString().trim()==""){
                    // Empty cells should always be ignored.
                    blnNoDataInCell = true
                }
                if((k>1 && params[k+','+0]!='null') || blnNoDataInCell) {
                    def sample

                    def startTime = params[1+','+j]
                    def subjectName = params[k+','+0]

                    if(blnNoDataInCell || !validCombinations[ startTime ] || !validCombinations[ startTime ].contains( subjectName ) ) {
                        if(!subjectTimepointConflicts.contains(['timepoint' : params[1+','+j], 'subjectName' : params[k+','+0]]) && !blnNoDataInCell){
                            subjectTimepointConflicts.add(['timepoint' : params[1+','+j], 'subjectName' : params[k+','+0]]);
                            // Here we don't add a timepoint/subjectName combination mmultiple times as this list is presented to the user, without any notion of features
                            // The reason why combinations might occur more than once is that they can occur with different features
                            // Also, we only add to this list in case the cell contains data
                        }
                        // Here we do add the combinations for each different feature as this list is used internally to represent which datapoints should never be saved to the database
                        ignore.add([k+","+j])
                    }
                }
            }
        }
        return ['subjectTimepointConflicts': subjectTimepointConflicts, 'ignore': ignore]
    }

    def buildCheckInputFlowObjects(int i, int j, text, edited_text, operator, comments){
        // This is a fresh start, so we will check the data for the occurence of values, operators and comments.
        edited_text[i][j] = text[i][j]
        def txt = edited_text[i][j]
        if(i>0 && j>0 && txt!=null && txt!=""){
            txt = txt.trim()

            if(!txt.isDouble()){
                // Apparently the value is not a valid double
                // Let us check if the problem is a comma (Dutch integer-fraction separator)
                def txt2 = txt.replace(',','.')
                if(txt2.isDouble()){
                    // That did the trick...
                    // Apparently the measurement used a comma inside it's Double value
                    // We replace the comma with a dot in order to be able to proceed with importing
                    txt = txt2
                }
            }

            // Values can have several formats:
            //  - double values are stored in the value
            //  - double values with a operator in front are stored in operator and value
            //  - all other values are stored in the comments
            if(!txt.isDouble()){
                // Apparently the value is not a valid double

                // Is the first character a valid operator? This can only happen
                // if the length of the string is 2 or larger. We perform the extra check
                // to avoid string-index out of bounds errors with the substring
                if(txt.size() >= 2 && Measurement.validOperators.contains(txt.substring(0,1)) && txt.substring(1).trim().isDouble()){
                    // Apparently, it is.
                    operator.put(i+","+j,txt.substring(0,1).trim())
                    edited_text[i][j] = Double.valueOf(txt.substring(1).trim())
                } else {
                    // Apparently it is not.
                    // We'll use the comments field instead.
                    comments.put(i+","+j,edited_text[i][j])
                    edited_text[i][j] = ""
                }
            } else {
                // This is a simple double value
                edited_text[i][j] = txt
            }
        }
        return ['operator': operator, 'comments': comments, 'edited_text': edited_text]
    }
}
