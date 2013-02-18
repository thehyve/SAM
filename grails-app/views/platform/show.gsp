<%@ page import="org.dbxp.sam.Platform" %>
<!DOCTYPE html>
<html>
	<head>
        <meta name="layout" content="sammain"/>
		<g:set var="entityName" value="${message(code: 'platform.label', default: 'Platform')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
    <content tag="contextmenu">
        <g:render template="contextmenu" />
    </content>
    <div class="data">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>

            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name"><g:message code="platform.name.label" default="Name"/></td>
                    <td valign="top" class="value">${platformInstance.name}</td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name"><g:message code="platform.platformtype.label" default="Platform Type"/></td>
                    <td valign="top" class="value">${platformInstance.platformtype}</td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name"><g:message code="platform.platformversion.label" default="Platform Version"/></td>
                    <td valign="top" class="value">${platformInstance.platformversion}</td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name"><g:message code="platform.comments.label" default="Comments"/></td>
                    <td valign="top" class="value">${platformInstance.comments}</td>
                </tr>

                </tbody>
            </table>
			<g:form>
				<fieldset class="buttons">
					<g:hiddenField name="id" value="${platformInstance?.id}" />
					<g:link class="edit" action="edit" id="${platformInstance?.id}"><g:message code="default.button.edit.label" default="Edit" /></g:link>
					<g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
				</fieldset>
			</g:form>
		</div>
	</body>
</html>
