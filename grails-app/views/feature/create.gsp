<%@ page import="org.dbxp.sam.Feature" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'feature.label', default: 'Feature')}"/>
    <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>

<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a>
    </span>
    <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label"
                                                                           args="[entityName]"/></g:link></span>
</div>

<div class="body">
    <h1><g:message code="default.create.label" args="[entityName]"/></h1>
    <g:hasErrors bean="${featureInstance}">
        <div class="errors">
            <g:renderErrors bean="${featureInstance}" as="list"/>
        </div>
    </g:hasErrors>
    <g:form action="save">
        <input type="hidden" name="nextPage" id="nextPage" value="list" />
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="name"><g:message code="feature.name.label" default="Name"/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: featureInstance, field: 'name', 'errors')}">
                        <g:textField name="name" value="${featureInstance?.name}"/>
                    </td>
                </tr>

                </tbody>
            </table>
        </div>

        <div class="buttons">
            <span class="button"><g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}"/></span>
            <span class="button"><g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}, ${message(code: 'default.button.edit.label', default: 'Edit')}" onclick="\$('#nextPage').val('edit');"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
