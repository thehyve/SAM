package org.dbxp.sam

import org.dbxp.moduleBase.Sample

class Measurement {

    static belongsTo = [sample:Sample, feature:Feature]
    String operator // '<', '>' or '='
    Double value
    String comments
    static final validOperators = ['<', '>', '=','',null]

    static mapping = {
        comments type: 'text'
    }

    static constraints = {
        value(blank:true,nullable:true)
        operator(blank:true,nullable:true,validator:{val,obj->val in obj.validOperators})
        comments(blank:true,nullable:true)
        sample(blank:false)
        feature(blank:false)
    }
}
