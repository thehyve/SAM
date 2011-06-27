package org.dbxp.sam

class FeatureGroup {

    String name

    static hasMany = [features:Feature]

    static constraints = {
        name(unique:false, blank:false)
    }
}
