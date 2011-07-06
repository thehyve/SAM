package org.dbxp.sam

class FeatureGroup implements Serializable {

    String name

    //static hasMany = [features:Feature]

    static constraints = {
        name(unique:false, blank:false)
    }
}
