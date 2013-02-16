package org.dbxp.sam

import org.springframework.dao.DataIntegrityViolationException

class PlatformController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    }

    def list(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        [platformInstanceList: Platform.list(params), platformInstanceTotal: Platform.count()]
    }

    def create() {
        [platformInstance: new Platform(params)]
    }

    def save() {
        def platformInstance = new Platform(params)

        if (!platformInstance.save(flush: true)) {
            render(view: "create", model: [platformInstance: platformInstance])
            return
        }

        flash.message = message(code: 'default.created.message', args: [message(code: 'platform.label', default: 'Platform'), platformInstance.id])
        redirect(action: "show", id: platformInstance.id)
    }

    def show(Long id) {
        def platformInstance = Platform.get(id)
        if (!platformInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'platform.label', default: 'Platform'), id])
            redirect(action: "list")
            return
        }

        [platformInstance: platformInstance]
    }

    def edit(Long id) {
        def platformInstance = Platform.get(id)
        if (!platformInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'platform.label', default: 'Platform'), id])
            redirect(action: "list")
            return
        }

        [platformInstance: platformInstance]
    }

    def update(Long id, Long version) {
        def platformInstance = Platform.get(id)
        if (!platformInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'platform.label', default: 'Platform'), id])
            redirect(action: "list")
            return
        }

        if (version != null) {
            if (platformInstance.version > version) {
                platformInstance.errors.rejectValue("version", "default.optimistic.locking.failure",
                          [message(code: 'platform.label', default: 'Platform')] as Object[],
                          "Another user has updated this Platform while you were editing")
                render(view: "edit", model: [platformInstance: platformInstance])
                return
            }
        }

        platformInstance.properties = params

        if (!platformInstance.save(flush: true)) {
            render(view: "edit", model: [platformInstance: platformInstance])
            return
        }

        flash.message = message(code: 'default.updated.message', args: [message(code: 'platform.label', default: 'Platform'), platformInstance.id])
        redirect(action: "show", id: platformInstance.id)
    }

    def delete(Long id) {
        def platformInstance = Platform.get(id)
        if (!platformInstance) {
            flash.message = message(code: 'default.not.found.message', args: [message(code: 'platform.label', default: 'Platform'), id])
            redirect(action: "list")
            return
        }

        try {
            platformInstance.delete(flush: true)
            flash.message = message(code: 'default.deleted.message', args: [message(code: 'platform.label', default: 'Platform'), id])
            redirect(action: "list")
        }
        catch (DataIntegrityViolationException e) {
            flash.message = message(code: 'default.not.deleted.message', args: [message(code: 'platform.label', default: 'Platform'), id])
            redirect(action: "show", id: id)
        }
    }
}
