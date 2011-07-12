<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <g:set var="entityName" value="${message(code: 'measurement.label', default: 'Measurement')}"/>
        <title><g:message code="default.show.label" args="[entityName]"/></title>
    </head>

    <body>
        <g:hasErrors bean="${measurementInstance}">
           <div class="errors">
               <g:renderErrors bean="${measurementInstance}" as="list"/>
           </div>
        </g:hasErrors>
        <content tag="contextmenu">
            <li><g:link class="list" controller="feature">List features</g:link></li>
            <li><g:link class="create" controller="feature" action="create">Create new feature</g:link></li>
            <li><g:link class="import" controller="measurement" action="importData">Import</g:link></li>
        </content>
        <h1><g:message code="default.show.label" args="[entityName]"/></h1>

        <div class="data">
            <g:form method="post">
                <g:hiddenField name="id" value="${measurementInstance?.id}"/>
                <g:hiddenField name="version" value="${measurementInstance?.version}"/>
                <div class="dialog">
                    <table>
                        <tbody>

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="measurement.id.label" default="Id"/></td>

                            <td valign="top" class="value">${fieldValue(bean: measurementInstance, field: "id")}</td>

                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="measurement.value.label" default="Value"/></td>

                            <td valign="top" class="value">${fieldValue(bean: measurementInstance, field: "value")}</td>

                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="measurement.operator.label" default="Operator"/></td>

                            <td valign="top" class="value">${fieldValue(bean: measurementInstance, field: "operator")}</td>

                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="measurement.comments.label" default="Comments"/></td>

                            <td valign="top" class="value">${fieldValue(bean: measurementInstance, field: "comments")}</td>

                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="measurement.sample.label" default="Sample"/></td>

                            <td valign="top" class="value"><g:link controller="sample" action="show"
                                                                   id="${measurementInstance?.sample?.id}">${measurementInstance?.sample?.encodeAsHTML()}</g:link></td>

                        </tr>

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="measurement.feature.label" default="Feature"/></td>

                            <td valign="top" class="value"><g:link controller="feature" action="show"
                                                                   id="${measurementInstance?.feature?.id}">${measurementInstance?.feature?.encodeAsHTML()}</g:link></td>

                        </tr>

                        </tbody>
                    </table>
                </div>

                <ul class="data_nav buttons">
                    <li><g:link controller="measurement" action="edit" id="${measurementInstance?.id}" class="edit">Edit</g:link></li>
                    <li><g:actionSubmit class="delete" action="delete" value="Delete" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></li>
                    <li><g:link controller="measurement" action="list" class="cancel">Cancel</g:link></li>
                </ul>
            </g:form>
        </div>
    </body>
</html>
