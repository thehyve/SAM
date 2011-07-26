<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Edit measurement</title>
    </head>

    <body>
        <content tag="contextmenu">
            <li><g:link class="list" controller="measurement">List measurements</g:link></li>
            <li><g:link class="create" controller="measurement" action="create">Create new measurement</g:link></li>
            <li><g:link class="import" controller="measurement" action="importData">Import</g:link></li>
        </content>
        <g:hasErrors bean="${measurementInstance}">
            <div class="errors">
                <g:renderErrors bean="${measurementInstance}" as="list"/>
            </div>
        </g:hasErrors>
        <h1>Edit measurement</h1>

        <div class="data">
            <g:form method="post">
                <g:hiddenField name="id" value="${measurementInstance?.id}"/>
                <g:hiddenField name="version" value="${measurementInstance?.version}"/>
                <div class="dialog">
                    <table>
                        <tbody>

                        <tr class="prop">
                            <td valign="top" class="name">
                                <label for="value"><g:message code="measurement.value.label" default="Value"/></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: measurementInstance, field: 'value', 'errors')}">
                                <g:textField name="value" value="${fieldValue(bean: measurementInstance, field: 'value')}"/>
                            </td>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                                <label for="operator"><g:message code="measurement.operator.label" default="Operator"/></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: measurementInstance, field: 'operator', 'errors')}">
                                <g:textField name="operator" value="${measurementInstance?.operator}"/>
                            </td>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                                <label for="comments"><g:message code="measurement.comments.label" default="Comments"/></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: measurementInstance, field: 'comments', 'errors')}">
                                <g:textField name="comments" value="${measurementInstance?.comments}"/>
                            </td>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                                <label for="sample"><g:message code="measurement.sample.label" default="Sample"/></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: measurementInstance, field: 'sample', 'errors')}">
                                <g:select name="sample.id" from="${org.dbxp.moduleBase.Sample.list()}" optionKey="id"
                                          value="${measurementInstance?.sample?.id}"/>
                            </td>
                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name">
                                <label for="feature"><g:message code="measurement.feature.label" default="Feature"/></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: measurementInstance, field: 'feature', 'errors')}">
                                <g:select name="feature.id" from="${org.dbxp.sam.Feature.list()}" optionKey="id"
                                          value="${measurementInstance?.feature?.id}"/>
                            </td>
                        </tr>

                        </tbody>
                    </table>
                </div>

                <ul class="data_nav buttons">
                    <li><g:actionSubmit class="save" action="update" value="Update"/></li>
                    <li><g:actionSubmit class="delete" action="delete" value="Delete" onclick="return confirm('Are you sure?');"/></li>
                    <li><g:link controller="measurement" action="list" class="cancel">Cancel</g:link></li>
                </ul>

            </g:form>
        </div>
    </body>
</html>
