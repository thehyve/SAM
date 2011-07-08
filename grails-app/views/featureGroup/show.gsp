<%@ page import="org.dbxp.sam.FeatureGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <g:set var="entityName" value="${message(code: 'featureGroup.label', default: 'FeatureGroup')}"/>
        <title><g:message code="default.show.label" args="[entityName]"/></title>
    </head>

    <body>
        <g:hasErrors bean="${featureGroupInstance}">
            <div class="errors">
                <g:renderErrors bean="${featureGroupInstance}" as="list"/>
            </div>
        </g:hasErrors>
        <h1><g:message code="default.show.label" args="[entityName]"/></h1>
        <content tag="contextmenu">
            <li><g:link controller="featureGroup">List feature groups</g:link></li>
            <li><g:link controller="featureGroup" action="create">Create new group</g:link></li>
        </content>
        <div class="data">
            <div class="dialog">
                <table>
                    <tbody>

                    <tr class="prop">
                        <td valign="top" class="name"><g:message code="featureGroup.id.label" default="Id"/></td>

                        <td valign="top" class="value">${fieldValue(bean: featureGroupInstance, field: "id")}</td>

                    </tr>

                    <tr class="prop">
                        <td valign="top" class="name"><g:message code="featureGroup.name.label" default="Name"/></td>

                        <td valign="top" class="value">${fieldValue(bean: featureGroupInstance, field: "name")}</td>

                    </tr>

                    </tbody>
                </table>
            </div>
            <br>
            <ul class="data_nav buttons">
                <li><g:link controller="featureGroup" action="edit" class="edit">Edit</g:link></li>
                <li><g:link controller="featureGroup" action="list" class="cancel">Cancel</g:link></li>
            </ul>
        </div>
    </body>
</html>
