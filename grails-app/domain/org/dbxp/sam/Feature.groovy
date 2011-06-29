package org.dbxp.sam

import org.dbnp.gdt.*

class Feature extends TemplateEntity {

    String name
    String unit

    static hasMany = [featureGroups:FeatureGroup]

    static belongsTo = FeatureGroup

    static constraints = {
        name(unique:true, blank:false)
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
			comment: "...")
	]
}