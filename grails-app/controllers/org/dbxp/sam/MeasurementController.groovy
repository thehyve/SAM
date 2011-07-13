package org.dbxp.sam

import org.dbxp.moduleBase.Auth
import grails.converters.JSON
import org.dbxp.moduleBase.Assay
import org.dbxp.matriximporter.MatrixImporter
import org.dbxp.matriximporter.CsvReader
import org.dbxp.matriximporter.ExcelReader

class MeasurementController {
    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

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
                session.assayList = [:]
                session.studyList = [:]
                Auth.findAllByUser(session.getValue('user')).each{
                    it.study.each { it2 ->
                        if(it2.canWrite(session.getValue('user'))){
                            it2.assays.each { assay ->
                                session.assayList.put(assay.assayToken, assay.name)
                                session.studyList.put(assay.assayToken, it2.name)
                            }
                        }
                    }
                }

                /* \(0_o)/ [Ugly hack to get around webflow implementation problem]
                 See :
                 - http://jira.grails.org/browse/GRAILS-6984
                 - http://stackoverflow.com/questions/1691853/grails-webflow-keeping-things-out-of-flow-scope
                */
                /* def remove = []
                flow.persistenceContext.getPersistenceContext().getEntitiesByKey().values().each { entity ->
                    if(!entity instanceof Serializable){
                        remove.add(entity)
                    }
                }
                remove.each {flow.persistenceContext.evict(it)}
                if(flash.size()!=0){
                    flash.values().each { entity ->
                        println entity.toString()+" - "+entity.getClass()
                    }
                    remove.each {flash.remove(it)}
                } */


                // Because the other solutions somehow don't get rid of a magical org.dbxp.moduleBase.Study object...
                // we will simply clear it
                flow.persistenceContext.clear()

                ['assayList' : session.assayList, 'studyList' : session.studyList]
            }
            on("success").to "chooseAssay"
        }

		chooseAssay {
			// Step 1: choose study and assay (update assay dropdown based on the study selected)
            render(view: 'chooseAssay')
			on("next") {
                def message = flow?.message // Save the message before clearing the flow
                String name = Assay.findByAssayToken(params.assay).name
                flow.persistenceContext.clear() // Get rid of the non-serializable assay (and incidentally all the rest...)
                flow.message = message // Re-fill our flow
                flow.assayToken = params.assay
                flow.studyName = params.study
                flow.assayName = name
			}.to "uploadData"
		}

		uploadData {
			// Step 2: upload data and give the user a preview. The user then chooses which layout he wants
			// to use.
            render(view: 'uploadData', model: ['assayToken': flow.assayToken, 'assayName': flow.assayName, 'studyName': flow.studyName])
			on("next") {
                def f = request.getFile('fileUpload')
                session.inputfile = f
			}.to "uploadDataCheck"
			on("previous") {
				// Save data of this step
				flow.input = [ "file": params.inputfile]
				flow.layout = params.layout
			}.to "chooseAssay"
		}

        uploadDataCheck {
            // Check to make sure we actually received a file.
            action {
                def f = session.inputfile
                def text = ""
                if(!f.empty) {
                    // Save data of this step
                    flow.message = "It appears this file cannot be read in." // In case we get an error before finishing
                    try{
                        new File( "./tempfolder/" ).mkdirs()
                        f.transferTo( new File( "./tempfolder/" + File.separatorChar + f.getOriginalFilename() ) )
                        File file = new File("./tempfolder/" + File.separatorChar + f.getOriginalFilename())
                        text = MatrixImporter.getInstance().importFile(file);
                        session.inputfile = file
                    } catch(Exception e) {
                        // Something went wrong with the file...
                        flow.message += " The precise error is as follows: "+e
                        return error()
                    }
                    flow.message = null
                    flow.input = [ "file": session.inputfile, "oringinalFilename": f.getOriginalFilename(), "text": text ]
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

			}.to "selectColumns"
			on("previous") {
				// Save data of this step

			}.to "uploadData"
        }

		selectColumns {
			// Step 3: Choose which features in the database match which column in the uploaded file
			on("next") {
				// Save data of this step
				flow.matching = params.matches
			}.to "checkInput"
			on("previous") {
				// Save data of this step
				flow.matching = params.matches
			}.to "uploadData"
		}
		checkInput {
			on("save").to "saveData"
			on("previous").to "selectColumns"
		}
		saveData {
			action {
				// Save data into the database 
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
