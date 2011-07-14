<%@ page import="org.dbxp.sam.FeatureGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <g:set var="entityName" value="${message(code: 'featureGroup.label', default: 'FeatureGroup')}"/>
        <title><g:message code="default.edit.label" args="[entityName]"/></title>
    </head>

    <body>
        <g:hasErrors bean="${featureGroupInstance}">
            <div class="errors">
                <g:renderErrors bean="${featureGroupInstance}" as="list"/>
            </div>
        </g:hasErrors>
        <h1><g:message code="default.edit.label" args="[entityName]"/></h1>
        <content tag="contextmenu">
            <li><g:link class="list" controller="featureGroup">List feature groups</g:link></li>
            <li><g:link class="create" controller="featureGroup" action="create">Create new group</g:link></li>
            <li><g:link class="list" controller="feature" action="list">List features</g:link></li>
        </content>
        <div class="data">
            <g:form method="post">
                <g:hiddenField name="id" value="${featureGroupInstance?.id}"/>
                <g:hiddenField name="version" value="${featureGroupInstance?.version}"/>
                <div class="dialog">
                    <table>
                        <tbody>

                        <tr class="prop">
                            <td valign="top" class="name">
                                <label for="name"><g:message code="featureGroup.name.label" default="Name"/></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: featureGroupInstance, field: 'name', 'errors')}">
                                <g:textField name="name" value="${featureGroupInstance?.name}"/>
                            </td>
                        </tr>

                        </tbody>
                    </table>
                </div>
                <br>
                <ul class="data_nav buttons">
                    <li><g:submitButton name="update" class="save" value="Update"/></li>
                    <li><g:link controller="featureGroup" action="list" class="cancel">Cancel</g:link></li>
                </ul>
            </g:form>
        </div>
    </body>
</html>
