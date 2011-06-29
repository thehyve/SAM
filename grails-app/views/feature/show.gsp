<%@ page import="org.dbxp.sam.Feature" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'feature.label', default: 'Feature')}"/>
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
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="dialog">
        <table>
            <tbody>

            <tr class="prop">
                <td valign="top" class="name"><g:message code="feature.id.label" default="Id"/></td>

                <td valign="top" class="value">${fieldValue(bean: featureInstance, field: "id")}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:message code="feature.name.label" default="Name"/></td>

                <td valign="top" class="value">${fieldValue(bean: featureInstance, field: "name")}</td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:message code="feature.featureGroups.label"
                                                         default="Feature Groups"/></td>

                <td valign="top" style="text-align: left;" class="value">
                    <ul>
                        <g:each in="${featureInstance.featureGroups}" var="f">
                            <li><g:link controller="featureGroup" action="show"
                                        id="${f.id}">${f?.encodeAsHTML()}</g:link></li>
                        </g:each>
                    </ul>
                </td>

            </tr>

            <tr class="prop">
                <td valign="top" class="name"><g:message code="feature.unit.label" default="Unit"/></td>

                <td valign="top" class="value">${fieldValue(bean: featureInstance, field: "unit")}</td>

            </tr>

            </tbody>
        </table>
        <hr>
        <% println "Template:"+featureInstance.template %>
        <hr>
    </div>

    <div class="buttons">
        <g:form>
            <g:hiddenField name="id" value="${featureInstance?.id}"/>
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
