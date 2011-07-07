package org.dbxp.sam

class FeaturesAndGroupsController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index = {
        redirect(action: "list", params: params)
    }

    def list = {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [featuresAndGroupsInstanceList: FeaturesAndGroups.list(params), featuresAndGroupsInstanceTotal: FeaturesAndGroups.count()]
    }

    def create = {
        def featuresAndGroupsInstance = new FeaturesAndGroups()
        featuresAndGroupsInstance.properties = params
        return [featuresAndGroupsInstance: featuresAndGroupsInstance]
    }

    def save = {
        def featuresAndGroupsInstance = new FeaturesAndGroups(params)
        if (featuresAndGroupsInstance.save(flush: true)) {
            flash.message = "${message(code: 'default.created.message', args: [message(code: 'featuresAndGroups.label', default: 'FeaturesAndGroups'), featuresAndGroupsInstance.id])}"
            redirect(action: "show", id: featuresAndGroupsInstance.id)
        }
        else {
            render(view: "create", model: [featuresAndGroupsInstance: featuresAndGroupsInstance])
        }
    }

    def show = {
        def featuresAndGroupsInstance = FeaturesAndGroups.get(params.id)
        if (!featuresAndGroupsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'featuresAndGroups.label', default: 'FeaturesAndGroups'), params.id])}"
            redirect(action: "list")
        }
        else {
            [featuresAndGroupsInstance: featuresAndGroupsInstance]
        }
    }

    def edit = {
        def featuresAndGroupsInstance = FeaturesAndGroups.get(params.id)
        if (!featuresAndGroupsInstance) {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'featuresAndGroups.label', default: 'FeaturesAndGroups'), params.id])}"
            redirect(action: "list")
        }
        else {
            return [featuresAndGroupsInstance: featuresAndGroupsInstance]
        }
    }

    def update = {
        def featuresAndGroupsInstance = FeaturesAndGroups.get(params.id)
        if (featuresAndGroupsInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (featuresAndGroupsInstance.version > version) {

                    featuresAndGroupsInstance.errors.rejectValue("version", "default.optimistic.locking.failure", [message(code: 'featuresAndGroups.label', default: 'FeaturesAndGroups')] as Object[], "Another user has updated this FeaturesAndGroups while you were editing")
                    render(view: "edit", model: [featuresAndGroupsInstance: featuresAndGroupsInstance])
                    return
                }
            }
            featuresAndGroupsInstance.properties = params
            if (!featuresAndGroupsInstance.hasErrors() && featuresAndGroupsInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'featuresAndGroups.label', default: 'FeaturesAndGroups'), featuresAndGroupsInstance.id])}"
                redirect(action: "show", id: featuresAndGroupsInstance.id)
            }
            else {
                render(view: "edit", model: [featuresAndGroupsInstance: featuresAndGroupsInstance])
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'featuresAndGroups.label', default: 'FeaturesAndGroups'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def featuresAndGroupsInstance = FeaturesAndGroups.get(params.id)
        if (featuresAndGroupsInstance) {
            try {
                featuresAndGroupsInstance.delete(flush: true)
                flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'featuresAndGroups.label', default: 'FeaturesAndGroups'), params.id])}"
                redirect(action: "list")
            }
            catch (org.springframework.dao.DataIntegrityViolationException e) {
                log.error(e)
                flash.message = "${message(code: 'default.not.deleted.message', args: [message(code: 'featuresAndGroups.label', default: 'FeaturesAndGroups'), params.id])}"
                redirect(action: "show", id: params.id)
            }
        }
        else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'featuresAndGroups.label', default: 'FeaturesAndGroups'), params.id])}"
            redirect(action: "list")
        }
    }
}
