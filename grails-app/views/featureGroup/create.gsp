<%@ page import="org.dbxp.sam.FeatureGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Create a new featureGroup</title>
    </head>

    <body>
        <g:hasErrors bean="${featureGroupInstance}">
            <div class="errors">
                <g:renderErrors bean="${featureGroupInstance}" as="list"/>
            </div>
        </g:hasErrors>
        <h1>Create a new featureGroup</h1>
        <content tag="contextmenu">
            <li><g:link class="list" controller="featureGroup">List feature groups</g:link></li>
            <li><g:link class="create" controller="featureGroup" action="create">Create new group</g:link></li>
            <li><g:link class="list" controller="feature" action="list">List features</g:link></li>
        </content>
        <div class="data">
            <g:form action="save">
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
                    <li><g:submitButton name="create" class="save" value="Create"/></li>
                    <li><g:link controller="featureGroup" action="list" class="cancel">Cancel</g:link></li>
                </ul>
            </g:form>
        </div>
    </body>
</html>
