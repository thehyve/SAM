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
        def measurementInstance = new Measurement(params)
        if (measurementInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'measurement.label', default: 'Measurement'), measurementInstance.id])}"
            redirect(action: "show", id: measurementInstance.id)
        }
        else {
            render(view: "create", model: [measurementInstance: measurementInstance])
        }
    }

    def show = {
        def measurementInstance = Measurement.get(params.id)
        if (!measurementInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'measurement.label', default: 'Measurement'), params.id])}"
            redirect(action: "list")
        }
        else {
            [measurementInstance: measurementInstance]
        }
    }

    def edit = {
        def measurementInstance = Measurement.get(params.id)
        if (!measurementInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'measurement.label', default: 'Measurement'), params.id])}"
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

                    measurementInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'measurement.label', default: 'Measurement')] as Object[], "Another user has updated this Measurement while you were editing")
                    render(view: "edit", model: [measurementInstance: measurementInstance])
                    return
                }
            }
            measurementInstance.properties = params
            if (!measurementInstance.hasErrors() && measurementInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'measurement.label', default: 'Measurement'), measurementInstance.id])}"
                redirect(action: "show", id: measurementInstance.id)
            }
            else {
                render(view: "edit", model: [measurementInstance: measurementInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'measurement.label', default: 'Measurement'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def measurementInstance = Measurement.get(params.id)
        if (measurementInstance) {
            try {
                measurementInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'measurement.label', default: 'Measurement'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'measurement.label', default: 'Measurement'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'measurement.label', default: 'Measurement'), params.id])}"
            redirect(action: "list")
        }
    }
	
	def importData = {
		redirect( action: 'importDataFlow' )
	}

	def importDataFlow = {
        /*def assayList = [:]
        def studyList = [:]
        def assayToken
        def assayName
        def studyName
        */
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
                String name = Assay.findByAssayToken(params.assay).name
                flow.assayToken = params.assay
                flow.studyName = params.study
                flow.assayName = name
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
                        // The converse is also true
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
                            flow.edited_text = null
                        }
                        
                        flow.text = text
                    } catch(Exception e) {
                        // Something went wrong with the file...
                        flow.message += " The precise error is as follows: "+e
                        return error()
                    }
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
                    // Try to match first row to features
                    def feature_matches = [:]
                    for(int i = 1; i < flow.text[0].size(); i++){
                        def match = fuzzySearchService.mostSimilar(flow.text[0][i], Feature.list().name)
                        feature_matches.put(flow.text[0][i], match)
                    }

                    // Try to match first column to samples
                    def patterns = []
                    for(int i = 1; i < flow.text.size(); i++){
                        patterns.push(flow.text[i][0]);
                    }
                    def samples = Assay.findByAssayToken(flow.assayToken).samples.name.toList()
                    def sample_matches_raw = fuzzySearchService.mostSimilarUnique(patterns.toList(), samples, 0)
                    def sample_matches = [:]
                    sample_matches_raw.each {
                        sample_matches.put(it.pattern, it.candidate)
                    }

                    flow.feature_matches = feature_matches.sort()
                    flow.sample_matches = sample_matches.sort()
                    flow.features = Feature.list().name
                    flow.features.sort()
                    flow.samples = samples.sort()
                } else {
                    println "subject layout not implemented yet..."
                }
			}.to "selectColumns"
			on("previous") {}.to "uploadData"
        }

		selectColumns {
			// Step 3: Choose which features in the database match which column in the uploaded file
			on("next") {
				// Save data of this step
                // This will be the data that will be saved

                if(flow.layout=="sample_layout"){
                    flow.edited_text = new Object[flow.text.size()][flow.text[0].size()]
                    for(int i = 0; i < flow.text.size(); i++){
                        for(int j = 0; j < flow.text[i].size(); j++){
                            if(params.get(i+","+j)){
                                flow.edited_text[i][j] = params.get(i+","+j)
                            } else {
                                flow.edited_text[i][j] = flow.text[i][j]
                            }
                        }
                    }
                } else {
                    println "subject layout not implemented yet..."
                }
			}.to "checkInput"
			on("previous") {
				// Save data of this step
                // This is done to be able to redo matching when going back to, for example, the selectLayout step

                if(params.layoutselector=="sample_layout"){
                    flow.edited_text = new Object[flow.text.size()][flow.text[0].size()]
                    for(int i = 0; i < flow.text.size(); i++){
                        for(int j = 0; j < flow.text[i].size(); j++){
                            if(params.get(i+","+j)){
                                flow.edited_text[i][j] = params.get(i+","+j)
                            } else {
                                flow.edited_text[i][j] = flow.text[i][j]
                            }
                        }
                    }
                } else {
                    println "subject layout not implemented yet..."
                }
			}.to "selectLayout"
		}
		checkInput {
			on("save").to "saveData"
			on("previous").to "selectColumns"
		}
		saveData {
			action {
				// Save data into the database
                flash.message = ""

                if(flow.layout=="sample_layout"){
                    def sList = [:]
                    Assay.findByAssayToken(flow.assayToken).samples.toList().each {
                        sList.put(it.name,it)
                    }
                    for(int i = 1; i < flow.edited_text.size(); i++){
                        // For a particular sample
                        def s = sList.get(flow.edited_text[i][0])
                        for(int j = 1; j < flow.edited_text[0].size(); j++){
                            // ... and a particular feature
                            def f = Feature.findByName(flow.edited_text[0][j])
                            // ... a measurement will be created

                            // Check if the measurement has an operator or is a comment
                            def operator
                            def comments
                            def val
                            if(!flow.edited_text[i][j].isDouble()){
                                // Apparantly the value is not a valid double

                                // Is the first character a valid operator?
                                if(Measurement.validOperators.contains(flow.edited_text[i][j].substring(0,1))){
                                    // Apparently, it is.
                                    operator = flow.edited_text[i][j].substring(0,1)
                                    val = Double.valueOf(flow.edited_text[i][j].substring(1))
                                } else {
                                    // Apparently it is not.
                                    // We'll use the comments field instead.
                                    comments = flow.edited_text[i][j]
                                }
                            } else {
                                // This is a simple double value
                                val = Double.valueOf(flow.edited_text[i][j])
                            }
                            try {
                                def m = new Measurement(sample:s,feature:f,value:val,operator:operator,comments:comments)
                                if(!m.save(flush : true)){
                                    flash.message += "<br>"+m.getErrors().allErrors
                                    println m.getErrors().allErrors
                                }
                            } catch(Exception e) {
                                flash.message += "<br>"+e
                                // TODO: better logging
                                println e
                            }
                        }
                    }
                } else {
                    println "subject layout not implemented yet..."
                }

                if(flash.message!=""){
                    flash.message = "There were errors while saving your measurements: "+flash.message
                } else {
                    flash.remove('message');
                }
			}
			on("success").to "finishScreen"
			on("error").to "errorSaving"
		}
		errorSaving {
			on( "previous" ).to "selectColumns"
		}
		finishScreen()
	}
	
}
