package org.dbxp.sam

import org.dbxp.moduleBase.Study;
import org.dbxp.matriximporter.*

class StudyController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]
	
	def synchronizationService
	
    def index = {
        redirect(action: "list", params: params)
    }
	
	def synchronize = {
		synchronizationService.initSynchronization( session.sessionToken, session.user ) ;
		synchronizationService.fullSynchronization();
		
		render "Synchronization succesful"
	}

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [studyInstanceList: Study.list(params), studyInstanceTotal: Study.count()]
    }

    def create = {
        def studyInstance = new Study()
        studyInstance.properties = params
        return [studyInstance: studyInstance]
    }

    def save = {
        def studyInstance = new Study(params)
        if (studyInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'study.label', default: 'Study'), studyInstance.id])}"
            redirect(action: "show", id: studyInstance.id)
        }
        else {
            render(view: "create", model: [studyInstance: studyInstance])
        }
    }

    def upload = {
		def f = request.getFile('fileUpload')
	    if(!f.empty) {
		  new File( "./tempfolder/" ).mkdirs()
		    f.transferTo( new File( "./tempfolder/" + File.separatorChar + f.getOriginalFilename() ) )
            flash.message = 'Your file'+f.getOriginalFilename()+' has been uploaded. Processing has not been implemented yet.'
		}
	    else {
	       flash.message = 'file cannot be empty'
	    }
		redirect( action:list)
	}

    def show = {
        def studyInstance = Study.get(params.id)
        if (!studyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'study.label', default: 'Study'), params.id])}"
            redirect(action: "list")
        }
        else {
            [studyInstance: studyInstance]
        }
    }

    def edit = {
        def studyInstance = Study.get(params.id)
        if (!studyInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'study.label', default: 'Study'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [studyInstance: studyInstance]
        }
    }

    def update = {
        def studyInstance = Study.get(params.id)
        if (studyInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (studyInstance.version > version) {
                    
                    studyInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'study.label', default: 'Study')] as Object[], "Another user has updated this Study while you were editing")
                    render(view: "edit", model: [studyInstance: studyInstance])
                    return
                }
            }
            studyInstance.properties = params
            if (!studyInstance.hasErrors() && studyInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'study.label', default: 'Study'), studyInstance.id])}"
                redirect(action: "show", id: studyInstance.id)
            }
            else {
                render(view: "edit", model: [studyInstance: studyInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'study.label', default: 'Study'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def studyInstance = Study.get(params.id)
        if (studyInstance) {
            try {
                studyInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'study.label', default: 'Study'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'study.label', default: 'Study'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'study.label', default: 'Study'), params.id])}"
            redirect(action: "list")
        }
    }
}
