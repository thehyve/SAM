<%@ page import="org.dbxp.sam.Feature" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Create a new feature</title>
    </head>

    <body>
        <g:hasErrors bean="${featureInstance}">
            <div class="errors">
                <g:renderErrors bean="${featureInstance}" as="list"/>
            </div>
        </g:hasErrors>
        <content tag="contextmenu">
      		<g:render template="contextmenu" />
        </content>
        <h1>Create a new feature</h1>

        <div class="data">
            You will be able to add additional detail to this feature by choosing the 'Create and edit' option.
            <g:form action="save">
                <input type="hidden" name="nextPage" id="nextPage" value="list" />
                <div class="dialog">
                    <table>
                        <tbody>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name">Name</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: featureInstance, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${featureInstance?.name}" size="maxlength"/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <ul class="data_nav buttons">
                    <li><g:submitButton name="create" class="save" value="Create"/></li>
                    <li><g:submitButton name="create" class="add" value="Create and edit" onclick="\$('#nextPage').val('edit');"/></li>
                    <li><g:link controller="feature" action="list" class="cancel">Cancel</g:link></li>
                </ul>
            </g:form>
        </div>
    </body>
</html>
