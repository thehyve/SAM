<%@ page import="org.dbxp.sam.Feature" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <g:set var="entityName" value="${message(code: 'feature.label', default: 'Feature')}"/>
        <title><g:message code="default.show.label" args="[entityName]"/></title>
    </head>
    <body>
        <div class="body">
            <h1><g:message code="default.show.label" args="[entityName]"/></h1>
            <div class="dialog">
                <table>
                    <tbody>
                        <g:each in="${featureInstance.giveFields()}" var="field">
                            <tr class="prop">
                                <td valign="top">
                                    ${field}
                                </td>
                                <td valign="top" >
                                    ${featureInstance.getFieldValue(field.toString())}
                                </td>
                            </tr>
                        </g:each>

                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="feature.featureGroups.label"
                                                                     default="Feature Groups"/></td>

                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                    <g:each in="${org.dbxp.sam.FeaturesAndGroups.findAllByFeature(featureInstance)}" var="f">
                                        <li><g:link controller="featureGroup" action="show"
                                                    id="${f?.featureGroup.id}">${f?.featureGroup.name.encodeAsHTML()}</g:link></li>
                                    </g:each>
                                </ul>
                            </td>

                        </tr>
                    </tbody>
                </table>
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
