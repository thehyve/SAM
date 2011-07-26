<%@ page import="org.dbxp.sam.FeatureGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>FeatureGroup ${featureGroupInstance.name}'s properties</title>
    </head>

    <body>
        <g:hasErrors bean="${featureGroupInstance}">
            <div class="errors">
                <g:renderErrors bean="${featureGroupInstance}" as="list"/>
            </div>
        </g:hasErrors>
        <h1>FeatureGroup ${featureGroupInstance.name}'s properties</h1>
        <content tag="contextmenu">
            <li><g:link class="list" controller="featureGroup">List feature groups</g:link></li>
            <li><g:link class="create" controller="featureGroup" action="create">Create new group</g:link></li>
            <li><g:link class="list" controller="feature" action="list">List features</g:link></li>
        </content>
        <div class="data">
            <div class="dialog">
                <table>
                    <tbody>
                    <tr class="prop">
                        <td valign="top" class="name"><g:message code="featureGroup.name.label" default="Name"/></td>
                        <td valign="top" class="value">${fieldValue(bean: featureGroupInstance, field: "name")}</td>
                    </tr>

                    <tr class="prop">
                        <td valign="top" class="name">Features</td>
                        <td valign="top" class="value">
                            <table>
                                <g:each in="${features}" var="f" status="i">
                                    <tr class="prop ${(i % 2) == 0 ? 'odd' : 'even'}">
                                        <td>
                                            <g:link controller="feature" action="show" id="${f.id}">${f.name}</g:link>
                                        </td>
                                    </tr>
                                </g:each>
                            </table>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <br>
            <ul class="data_nav buttons">
                <g:form>
                    <g:hiddenField name="id" value="${featureGroupInstance?.id}"/>
                    <li><g:actionSubmit class="edit" action="edit" value="Edit"/></li>
                    <li><g:actionSubmit class="delete" action="delete" value="Delete" onclick="return confirm('Are you sure?');"/></li>
                    <li><g:link controller="featureGroup" action="list" class="cancel">Back to list</g:link></li>
                </g:form>
            </ul>
        </div>
    </body>
</html>
