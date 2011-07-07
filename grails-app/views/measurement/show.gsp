<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'measurement.label', default: 'Measurement')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>

<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a>
    </span>
    <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label"
                                                                           args="[entityName]"/></g:link></span>
    <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label"
                                                                               args="[entityName]"/></g:link></span>
</div>

<div class="body">
    <h1><g:message code="default.show.label" args="[entityName]"/></h1>
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

    <div class="buttons">
        <g:form>
            <g:hiddenField name="id" value="${measurementInstance?.id}"/>
            <span class="button"><g:actionSubmit class="edit" action="edit"
                                                 value="${message(code: 'default.button.edit.label', default: 'Edit')}"/></span>
            <span class="button"><g:actionSubmit class="delete" action="delete"
                                                 value="${message(code: 'default.button.delete.label', default: 'Delete')}"
                                                 onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
        </g:form>
    </div>
</div>
</body>
</html>
