package org.dbxp.sam

import org.dbnp.gdt.*
import org.apache.log4j.Logger

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

	public def getFeatureGroups() {
		return FeatureGroup.executeQuery( "SELECT DISTINCT fg FROM FeatureGroup fg, FeaturesAndGroups fag WHERE fag.featureGroup = fg AND fag.feature = :feature", [ "feature": this ] )
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


    def static delete(toDeleteList){
        def hasBeenDeletedList = []
        def return_map = [:]

        String strMessage = ""
        boolean error = false;
        Logger log
        for( it in toDeleteList) {
            def name
            try{
                def featureInstance = Feature.get(it)
                name = featureInstance.toString()
                if(Measurement.findByFeature(featureInstance)){
                    if(error==false){
                        log = Logger.getLogger(Feature)
                        error = true
                    } else {
                        strMessage += "<br>"
                    }
                    strMessage += "Feature "+name+" cannot be deleted at this moment because it is still referenced by measurements."
                    continue;
                }
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
            } catch(Exception e){
                if(error==false){
                    log = Logger.getLogger(Feature)
                    error = true
                } else {
                    strMessage += "<br>"
                }
                log.error e
                strMessage += "Something went wrong when trying to delete "
                if(name!=null && name!=""){
                    strMessage += name+". The probable cause is that the feature was already deleted."
                } else {
                    strMessage += "a feature. The probable cause is that the feature was already deleted."
                }
            }
        }
        if(!error){
            if(hasBeenDeletedList.size()==1){
                return_map["message"] = "The feature "+hasBeenDeletedList[0]+" has been deleted."
            } else {
                return_map["message"] = "The following features have been deleted: "+hasBeenDeletedList.toString()
            }
        } else {
            if(hasBeenDeletedList.size()!=0){
                strMessage += "<br><br>The following features have been deleted: "+hasBeenDeletedList.toString()
            }
            return_map["message"] = strMessage
        }
        return_map["action"] = "list"
        return return_map
    }
}