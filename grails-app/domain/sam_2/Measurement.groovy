package sam_2

import org.dbxp.moduleBase.Sample

class Measurement {

    static belongsTo = [sample:Sample, feature:Feature]
    String operator
    double value
    String comments

    static mapping = {
        comments type: 'text'
    }

    static constraints = {
        value(blank:false)
        operator(blank:true)
        comments(blank:true)
        sample(blank:false)
        feature(blank:false)
    }
}
