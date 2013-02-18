package org.dbxp.sam

import org.dbnp.gdt.*

class Platform extends TemplateEntity {

    String name
    String platformversion
    String platformtype
    String comments

    /**
     * return the domain fields for this domain class
     * @return List
     */
    @Override
    List<TemplateField> giveDomainFields() { return domainFields }

    static final List<TemplateField> domainFields = [
            new TemplateField(
                    name: 'name',
                    type: TemplateFieldType.STRING,
                    preferredIdentifier: true,
                    comment: 'The name of the platform',
                    required: true),
            new TemplateField(
                    name: 'platformversion',
                    type: TemplateFieldType.STRING,
                    comment: 'The version of the platform',
                    required: false),
            new TemplateField(
                    name: 'platformtype',
                    type: TemplateFieldType.STRING,
                    comment: 'Platform type',
                    required: false),
            new TemplateField(
                    name: 'comments',
                    type: TemplateFieldType.TEXT,
                    comment: "The measurement unit of the feature",
                    required: false)
    ]

    public String toString() {
        name
    }

    static constraints = {
        name(nullable:false, blank: false, unique:true, maxSize: 255)
    }

    static mapping = {
        cache true
        autoTimestamp true
        sort "name"

        // Make sure the TEXT field description is persisted with a TEXT field in the database
        comments type: 'text'
        // Workaround for bug http://jira.codehaus.org/browse/GRAILS-6754
        templateTextFields type: 'text'

    }
}