package org.dbxp.sam

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
            flash.message = "FeatureGroup ${featureGroupInstance.name} has been created."
            redirect(action: "show", id: featureGroupInstance.id)
        }
        else {
            render(view: "create", model: [featureGroupInstance: featureGroupInstance])
        }
    }

    def show = {
        def featureGroupInstance = FeatureGroup.get(params.id)
        def features = org.dbxp.sam.FeaturesAndGroups.findAllByFeatureGroup(featureGroupInstance).feature.toList()
        if (!featureGroupInstance) {
            flash.message = "The requested featureGroup could not be found."
            redirect(action: "list")
        }
        else {
            [featureGroupInstance: featureGroupInstance, features: features]
        }
    }

    def edit = {
        def featureGroupInstance = FeatureGroup.get(params.id)
        def features = Feature.list()
        if (!featureGroupInstance) {
            flash.message = "The requested featureGroup could not be found."
            redirect(action: "list")
        }
        else {
            return [featureGroupInstance: featureGroupInstance, features:features]
        }
    }

    def update = {
        def featureGroupInstance = FeatureGroup.get(params.id)
        if (featureGroupInstance) {
            if (params.version) {
                def version = params.version.toLong()
                if (featureGroupInstance.version > version) {

                    featureGroupInstance.errors.rejectValue("Another user has updated this featureGroup while you were editing. Because of this, your changes have not been saved to the database.")
                    render(view: "edit", model: [featureGroupInstance: featureGroupInstance])
                    return
                }
            }
            featureGroupInstance.properties = params
            if (!featureGroupInstance.hasErrors() && featureGroupInstance.save(flush: true)) {
                flash.message = "The featureGroup has been updated."
                redirect(action: "show", id: featureGroupInstance.id)
            }
            else {
                render(view: "edit", model: [featureGroupInstance: featureGroupInstance])
            }
        }
        else {
            flash.message = "The requested featureGroup could not be found."
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
			def featureGroupInstance = FeatureGroup.get(id)
	        if (featureGroupInstance) {
                try {
					def FaGList = FeaturesAndGroups.findAllByFeatureGroup(featureGroupInstance)
					if(FaGList.size()!=0){
						FaGList.each {
							it.delete(flush: true)
						}
					}
					
					featureGroupInstance.delete(flush: true)
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
			flash.message = "1 feature group has been deleted from the database"
		if( numDeleted > 1 )
			flash.message = numDeleted + " feature groups have been deleted from the database"
		
		flash.error = ""
		if( numNotFound == 1 )
			flash.error += "1 feature group has been deleted before." 
		if( numNotFound > 1 )
			flash.error += numNotFound+ " feature groups have been deleted before." 

		if( numErrors == 1 )
			flash.error += "1 feature group could not be deleted. Please try again" 
		if( numErrors > 1 )
			flash.error += numErrors + " feature groups could not be deleted. Please try again" 
		
		redirect(action: "list")
    }

    def deleteMultiple = {
        def toDeleteList = []

        if(params?.fgMassDelete!=null){
            if(params.fgMassDelete.class!="".class){
                toDeleteList = params.fgMassDelete
            } else {
                toDeleteList.push(params.fgMassDelete)
            }
        }

        if(toDeleteList.size()>0){
            def return_map = [:]
            return_map = FeatureGroup.deleteMultipleFeatureGroups(toDeleteList)
            def error = return_map.get("error")
            if(error){
                log.error(error)
            }
            def message = return_map.get("message")
            if(message){
                flash.message = message
            }
            def action = return_map.get("action")
            if(action){
                redirect(action: action)
            } else {
                redirect(action:list)
            }
        } else {
            flash.message = "No feature groups were marked when the delete button was clicked, so no feature groups were deleted."
            redirect(action: "list")
        }
    }
}