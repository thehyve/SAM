package sam_2

import org.dbxp.sam.Feature
import org.dbxp.sam.FeaturesAndGroups
import org.dbxp.sam.FeatureGroup

class SamService {

    static transactional = true

    def serviceMethod() {

    }

    def deleteMultipleFeatures(toDeleteList){
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
                log.error(e)
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

    def deleteMultipleFeatureGroups(toDeleteList){
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
                log.error(e)
                return_map["message"] = "Something went wrong when trying to delete "
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