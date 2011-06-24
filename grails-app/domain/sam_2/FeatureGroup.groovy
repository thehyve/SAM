package sam_2

class FeatureGroup {

    String name

    static hasMany = [features:Feature]

    static constraints = {
        name(unique:false, blank:false)
    }
}
