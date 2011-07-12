package org.dbxp.sam

class FeaturesAndGroups implements Serializable {

    FeatureGroup featureGroup
    Feature feature

    static mapping = {
        version false
    }

    static FeaturesAndGroups create(FeatureGroup featureGroup1, Feature feature1, boolean flush = false){
        if(FeaturesAndGroups.findAllByFeature(feature1).featureGroup.contains(featureGroup1)){
            return null; // This connection already existed, so we don't want to add it again
        }
        FeaturesAndGroups featuresAndGroups = new FeaturesAndGroups(featureGroup : featureGroup1, feature : feature1)
        featuresAndGroups.save(flush : flush)
        return featuresAndGroups
    }

    static boolean remove(FeatureGroup featureGroup1, Feature feature1, boolean flush = false){
        FeaturesAndGroups featuresAndGroups = FeaturesAndGroups.findByFeatureAndFeatureGroup(feature1, featureGroup1)
        boolean success = featuresAndGroups.delete(flush : flush);
        return success
    }

    static void removeAllFeaturesFromFeatureGroup(FeatureGroup featureGroup1, boolean flush = false){
        FeaturesAndGroups featuresAndGroups = FeaturesAndGroups.findAllFeatureGroup(featureGroup1)
        featuresAndGroups.each{
            println it;
        }
    }
}
