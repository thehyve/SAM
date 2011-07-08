package org.dbxp.sam

class FeatureGroup implements Serializable {

    String name

    //static hasMany = [features:Feature]

    static constraints = {
        name(unique:false, blank:false)
    }

    def static deleteMultipleFeatureGroups(toDeleteList){
        def hasBeenDeletedList = []
        def return_map = [:]

        for( it in toDeleteList) {
            try{
                def featureGroupInstance = FeatureGroup.get(it)
                def name = featureGroupInstance.name
                def FaGList = FeaturesAndGroups.findAllByFeatureGroup(featureGroupInstance)
                if(FaGList.size()==0){
                    featureGroupInstance.delete(flush: true)
                } else {
                    FaGList.each {
                        it.delete(flush: true)
                    }
                    featureGroupInstance.delete(flush: true)
                }
                hasBeenDeletedList.push(name);
                return_map.put("message", "The following groups were succesfully deleted: "+hasBeenDeletedList.toString())
                return_map.put("action", "list")
            } catch(Exception e){
                return_map["message"] = "Something went wrong when trying to delete "
                return_map["error"] = e
                //return_map.put("message", "Something went wrong when trying to delete ")
                if(toDeleteList.size()==1){
                    return_map.put("message", return_map.get("message")+" the group. The probable cause is that the group was already deleted.<br>"+e)
                } else {
                    if(hasBeenDeletedList.size()==0){
                        return_map.put("message", return_map.get("message")+" one or more groups. The probable cause is that these were already deleted.<br>"+e)
                    } else {
                        return_map.put("message", " the features.<br>The following groups were succesfully deleted: "+hasBeenDeletedList.toString()+"<br>"+e)
                    }
                }
                return_map.put("action", "list")
                return return_map
            }
        }
        return return_map
    }
}
