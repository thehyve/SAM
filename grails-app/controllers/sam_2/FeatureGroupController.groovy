package sam_2

class FeatureGroupController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [featureGroupInstanceList: FeatureGroup.list(params), featureGroupInstanceTotal: FeatureGroup.count()]
    }

    def create = {
        def featureGroupInstance = new FeatureGroup()
        featureGroupInstance.properties = params
        return [featureGroupInstance: featureGroupInstance]
    }

    def save = {
        def featureGroupInstance = new FeatureGroup(params)
        if (featureGroupInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'featureGroup.label', default: 'FeatureGroup'), featureGroupInstance.id])}"
            redirect(action: "show", id: featureGroupInstance.id)
        }
        else {
            render(view: "create", model: [featureGroupInstance: featureGroupInstance])
        }
    }

    def show = {
        def featureGroupInstance = FeatureGroup.get(params.id)
        if (!featureGroupInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'featureGroup.label', default: 'FeatureGroup'), params.id])}"
            redirect(action: "list")
        }
        else {
            [featureGroupInstance: featureGroupInstance]
        }
    }

    def edit = {
        def featureGroupInstance = FeatureGroup.get(params.id)
        if (!featureGroupInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'featureGroup.label', default: 'FeatureGroup'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [featureGroupInstance: featureGroupInstance]
        }
    }

    def update = {
        def featureGroupInstance = FeatureGroup.get(params.id)
        if (featureGroupInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (featureGroupInstance.version > version) {

                    featureGroupInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'featureGroup.label', default: 'FeatureGroup')] as Object[], "Another user has updated this FeatureGroup while you were editing")
                    render(view: "edit", model: [featureGroupInstance: featureGroupInstance])
                    return
                }
            }
            featureGroupInstance.properties = params
            if (!featureGroupInstance.hasErrors() && featureGroupInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'featureGroup.label', default: 'FeatureGroup'), featureGroupInstance.id])}"
                redirect(action: "show", id: featureGroupInstance.id)
            }
            else {
                render(view: "edit", model: [featureGroupInstance: featureGroupInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'featureGroup.label', default: 'FeatureGroup'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def featureGroupInstance = FeatureGroup.get(params.id)
        if (featureGroupInstance) {
            try {
                featureGroupInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'featureGroup.label', default: 'FeatureGroup'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'featureGroup.label', default: 'FeatureGroup'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'featureGroup.label', default: 'FeatureGroup'), params.id])}"
            redirect(action: "list")
        }
    }
}
