package org.dbxp.sam

import org.dbxp.matriximporter.MatrixImporter
import org.dbxp.moduleBase.Assay
import org.dbxp.moduleBase.Auth

class MeasurementController {
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
    def fuzzySearchService

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        //params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [measurementInstanceList: Measurement.list(params), measurementInstanceTotal: Measurement.count()]
    }

    def create = {
        def measurementInstance = new Measurement()
        measurementInstance.properties = params
        return [measurementInstance: measurementInstance]
    }

    def save = {
        def measurementInstance = new Measurement( params )
		
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
            render(view: "create", model: [measurementInstance: measurementInstance])
        }
    }

    def show = {
        def measurementInstance = Measurement.get(params.id)
        if (!measurementInstance) {
            flash.message = "The requested measurement could not be found."
            redirect(action: "list")
        }
        else {
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
		
		redirect(action: "list")
    }
	
	def importData = {
		redirect( action: 'importDataFlow' )
	}

	def importDataFlow = {

        startUp {
            action{
                flow.assayList = [:]
                flow.studyList = [:]
                Auth.findAllByUser(session.getValue('user')).each{
                    it.study.each { it2 ->
                        if(it2.canWrite(session.getValue('user'))){
                            it2.assays.each { assay ->
                                flow.assayList.put(assay.assayToken, assay.name)
                                flow.studyList.put(assay.assayToken, it2.name)
                            }
                        }
                    }
                }
            }
            on("success").to "chooseAssay"
        }

		chooseAssay {
			// Step 1: choose study and assay (update assay dropdown based on the study selected)
			on("next") {
                flow.assay = Assay.findByAssayToken(params.assay)
                flow.studyName = params.study
			}.to "uploadData"
		}

		uploadData {
			// Step 2: upload data and give the user a preview. The user then chooses which layout he wants
			// to use.
			on("next") {
                flow.inputfile = request.getFile('fileUpload')
			}.to "uploadDataCheck"
			on("previous"){}.to "chooseAssay"
		}

        uploadDataCheck {
            // Check to make sure we actually received a file.
            action {
                def f = flow.inputfile
                def text = ""
                if(!f.empty) {
                    // Save data of this step
                    flow.message = "It appears this file cannot be read in." // In case we get an error before finishing
                    try{
                        new File( "./tempfolder/" ).mkdirs()
                        f.transferTo( new File( "./tempfolder/" + File.separatorChar + f.getOriginalFilename() ) )
                        File file = new File("./tempfolder/" + File.separatorChar + f.getOriginalFilename())
                        text = MatrixImporter.getInstance().importFile(file);
                    } catch(Exception e){
                        // Something went wrong with the file...
                        flow.message += " The precise error is as follows: "+e
                        return error()
                    }

                    // In the following section we will try to find out what layout the data in this file has
                    def sampl = 0
                    def subj = 0

                    if(text[1][0]==null || text[1][0]==""){
                        // Cell A2 empty? That would indicate subject layout.
                        // It is also a pretty good sign that this is not a sample layout
                        subj++
                        sampl--
                    } else {
                        // IT cell A2 is not empty, it supports a conclusion of sample layout,
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

                    // Do we already have some manual selections?
                    // If our text did not change, we can re-use them.
                    if(flow.edited_text != null && flow.text != text){
                        // It appears we cannot reuse them
                        flow.edited_text = null
                        flow.operator = null
                        flow.comments = null
                    }

                    flow.text = text
                    flow.message = null
                    flow.input = [ "file": flow.inputfile, "originalFilename": f.getOriginalFilename()]
                }
                else {
                    flow.message = 'Make sure to add a file using the upload field below. The file upload field cannot be empty.'
                    return error()
                }
            }
            on("success").to "selectLayout"
            on("error").to "uploadData"
        }

        selectLayout {
            // Step x: Choose layout, preview data
			on("next") {
				// Save data of this step
                flow.layout = params.layoutselector

                def possible_matches = [:]
                if(params.layoutselector=="sample_layout"){
                    flow.features = Feature.list().sort(){it.name}
                    flow.samples = flow.assay.samples.sort(){it.name}

                    // Try to match first row to features
                    flow.feature_matches = [:]
                    for(int i = 1; i < flow.text[0].size(); i++){
                        def index = fuzzySearchService.mostSimilarWithIndex(flow.text[0][i], flow.features*.toString())
                        if(index!=null){
                            flow.feature_matches[flow.text[0][i]] = index
                        } else {
                            flow.feature_matches[flow.text[0][i]] = 0
                        }
                    }
                    // Try to match first column to samples
                    flow.sample_matches = [:]
                    for(int i = 1; i < flow.text.size(); i++){
                        def index = fuzzySearchService.mostSimilarWithIndex(flow.text[i][0], flow.samples.name)
                        if(index!=null){
                            flow.sample_matches[flow.text[i][0]] = index
                        } else {
                            flow.sample_matches[flow.text[i][0]] = 0
                        }
                    }
                } else {
                    flow.features = Feature.list().sort(){it.name}
                    def samples = flow.assay.samples
                    flow.timepoints = samples.eventStartTime.unique()
                    flow.subjects = samples.subjectName

                    // Try to match first row to features
                    flow.feature_matches = [:]
                    for(int i = 1; i < flow.text[0].size(); i++){
                        def index = fuzzySearchService.mostSimilarWithIndex(flow.text[0][i], flow.features*.toString())
                        if(index!=null){
                            flow.feature_matches[flow.text[0][i]] = index
                        } else {
                            flow.feature_matches[flow.text[0][i]] = 0
                        }
                    }
                    // Try to match second row to timepoints
                    flow.timepoint_matches = [:]
                    for(int i = 1; i < flow.text[1].size(); i++){
                        def index = fuzzySearchService.mostSimilarWithIndex(flow.text[1][i], flow.timepoints)
                        if(index!=null){
                            flow.timepoint_matches[flow.text[1][i]] = index
                        } else {
                            flow.timepoint_matches[flow.text[1][i]] = 0
                        }
                    }
                    // Try to match first column to subjects
                    flow.subject_matches = [:]
                    for(int i = 2; i < flow.text.size(); i++){
                        def index = fuzzySearchService.mostSimilarWithIndex(flow.text[i][0], flow.subjects)
                        if(index!=null){
                            flow.subject_matches[flow.text[i][0]] = index
                        } else {
                            flow.subject_matches[flow.text[i][0]] = 0
                        }
                    }
                }
			}.to "selectColumns"
			on("previous") {}.to "uploadData"
        }

		selectColumns {
			// Step 3: Choose which features in the database match which column in the uploaded file
			on("next") {
				// Save data of this step and make some more information available about the contents of the cells
                if(!flow.operator){
                    flow.operator = [:]
                }
                if(!flow.comments){
                    flow.comments = [:]
                }

                println "\n\n\n\n\nparams: "
                params.each {
                    println it.key+" -> "+it.value+"\t\t\t\t"+it.value.class
                }
                println "\n\n\n\n\n"

                // Generate extra information about cell contents and fold the user's selections into our data storage object flow.edited_text
                if(!flow.edited_text){
                    flow.edited_text = new Object[flow.text.size()][flow.text[0].size()]
                    for(int i = 0; i < flow.text.size(); i++){
                        for(int j = 0; j < flow.text[i].size(); j++){
                            if(params[i+','+j]){
                                println params[i+','+j]+"   "+params[i+','+j].class
                                // Here we are catching a user's feature or sample selection from the previous page and incorporating it into our new dataset
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
                                        continue;
                                    }
                                }                            } else {
                                flow.edited_text[i][j] = flow.text[i][j]
                                def txt = flow.edited_text[i][j]
                                if(i>0 && j>0 && txt!=null && txt!=""){
                                    txt = txt.trim()
                                    if(!txt.isDouble()){
                                        // Apparently the value is not a valid double

                                        // Is the first character a valid operator?
                                        if(Measurement.validOperators.contains(txt.substring(0,1)) && txt.substring(1).trim().isDouble()){
                                            // Apparently, it is.
                                            flow.operator.put(i+","+j,txt.substring(0,1).trim())
                                            flow.edited_text[i][j] = Double.valueOf(txt.substring(1).trim())
                                        } else {
                                            // Apparently it is not.
                                            // We'll use the comments field instead.
                                            flow.comments.put(i+","+j,flow.edited_text[i][j])
                                            flow.edited_text[i][j] = ""
                                        }
                                    } else {
                                        // This is a simple double value
                                        // We don't need to save more information than contained in flow.edited_text
                                    }
                                }
                            }
                        }
                    }
                }
			}.to "checkInput"
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
			}.to "selectLayout"
		}

		checkInput {
			on("save").to "saveData"
			on("previous"){
                // Save edits into the flow.edited_text object
                for(int i = 1; i < flow.edited_text.size(); i++){
                    for(int j = 1; j < flow.edited_text[0].size(); j++){
                        def txt = params?.get('valueHidden'+i+','+j)
                        def comm = params?.get('commentHidden'+i+','+j)
                        def op = params?.get('operatorHidden'+i+','+j)
                        if(txt.class==java.lang.String){
                            flow.edited_text[i][j] = txt
                        }
                        if(op.class==java.lang.String){
                            if(op==""){
                                flow.operator.remove(i+","+j)
                            } else {
                                flow.operator.put(i+","+j,op)
                            }
                        }
                        if(comm.class==java.lang.String){
                            if(comm==""){
                                flow.comments.remove(i+","+j)
                            } else {
                                flow.comments.put(i+","+j,comm)
                            }
                        }

                    }
                }
            }.to "selectColumns"
		}

		saveData {
			action {
				// Save data into the database
                flash.message = ""

                def measurementList = []
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
                                    def txt = params?.get('valueHidden'+i+','+j)
                                    def comm = params?.get('commentHidden'+i+','+j)
                                    def op = params?.get('operatorHidden'+i+','+j)
                                    flow.edited_text[i][j] = op+""+txt+" "+comm
                                    measurementList.add(importerCreateMeasurement(s, f, txt, comm, op));
                                }
                            }
                        }
                    }
                } else {
                    for(int i = 1; i < flow.edited_text.size(); i++){
                        if(flow.edited_text[i][0]!=null && flow.edited_text[i][0]!="null"){
                            for(int j = 1; j < flow.edited_text[0].size(); j++){
                                if(i>1 && flow.edited_text[0][j]!=null && flow.edited_text[0][j]!="null"){
                                    // For a particular subject and a particular timepoint and thus a particular sample
                                    SAMSample s = SAMSample.findByEventStartTimeAndSubjectName(flow.edited_text[1][j], flow.edited_text[i][0]);
                                    // ... and a particular feature
                                    Feature f = flow.edited_text[0][j]
                                    // ... a measurement will be created
                                    def txt = params?.get('valueHidden'+i+','+j)
                                    def comm = params?.get('commentHidden'+i+','+j)
                                    def op = params?.get('operatorHidden'+i+','+j)
                                    flow.edited_text[i][j] = op+""+txt+" "+comm
                                    measurementList.add(importerCreateMeasurement(s, f, txt, comm, op));
                                }
                            }
                        }
                    }
                }

                Measurement.withTransaction {
                    status ->
                    measurementList.each {
                        m ->
                        if(!m.save(flush : true)){
                            flash.message += "<br>"+m.getErrors().allErrors
                            println m.getErrors().allErrors
                            status.setRollbackOnly();
                        }
                    }
                }

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
			on("previous").to "checkInput"
		}

        finishScreen()
	}

    Measurement importerCreateMeasurement(SAMSample s, Feature f, def txt, def comm, def op) {
        def operator
        def comments
        def val

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

        return new Measurement(sample:s,feature:f,value:val,operator:operator,comments:comments)
    }

}
