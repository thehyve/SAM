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
			comment: "...")
	]
}