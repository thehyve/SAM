package org.dbxp.sam

import org.dbnp.gdt.*

class Feature extends TemplateEntity {

    String name
    String unit

    //static hasMany = [featureGroups:FeatureGroup]

    //static belongsTo = FeatureGroup

    static constraints = {
        name(unique:true, blank:false)
        unit(nullable:true, blank:true)
    }

    public String toString() {
		return name + ( unit!=null ? " ("+unit+")" : "" )
	}

	/**
	 * Changes the template for this feature. If no template with the given name 
	 * exists, the template is set to null.
	 * @param templateName	Name of the new template
	 * @return	True if the change is successful, false otherwise
	 */
	public boolean changeTemplate( String templateName ) {
		this.template = Template.findAllByName( templateName ).find { it.entity == this.class }
	}
	
    /**
	 * return the domain fields for this domain class
	 * @return List
	 */
	static List<TemplateField> giveDomainFields() { return Feature.domainFields }

    static List<TemplateField> domainFields = [
		new TemplateField(
			name: 'name',
			type: TemplateFieldType.STRING,
			preferredIdentifier: true,
			comment: '...',
			required: true),
		new TemplateField(
			name: 'unit',
			type: TemplateFieldType.STRING,
			comment: "...",
			required: false)
	]


    def static deleteMultipleFeatures(toDeleteList){
        def hasBeenDeletedList = []
        def return_map = [:]

        for( it in toDeleteList) {
            try{
                def featureInstance = Feature.get(it)
                def name = featureInstance.name
                def FaGList = FeaturesAndGroups.findAllByFeature(featureInstance)
                if(FaGList.size()==0){
                    featureInstance.delete(flush: true)
                } else {
                    FaGList.each {
                        it.delete(flush: true)
                    }
                    featureInstance.delete(flush: true)
                }
                hasBeenDeletedList.push(name);
                return_map.put("message", "The following features were succesfully deleted: "+hasBeenDeletedList.toString())
                return_map.put("action", "list")
            } catch(Exception e){
                return_map["error"] = e
                return_map["message"] = "Something went wrong when trying to delete "
                //return_map.put("message", "Something went wrong when trying to delete ")
                if(toDeleteList.size()==1){
                    return_map.put("message", return_map.get("message")+" the feature. The probable cause is that the feature was already deleted.<br>"+e)
                } else {
                    if(hasBeenDeletedList.size()==0){
                        return_map.put("message", return_map.get("message")+" one or more features. The probable cause is that these were already deleted.<br>"+e)
                    } else {
                        return_map.put("message", " the features.<br>The following features were succesfully deleted: "+hasBeenDeletedList.toString()+"<br>"+e)
                    }
                }
                return_map.put("action", "list")
                return return_map
            }
        }
        return return_map
    }
}