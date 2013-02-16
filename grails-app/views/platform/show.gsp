
<%@ page import="org.dbxp.sam.Platform" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'platform.label', default: 'Platform')}" />
		<title><g:message code="default.show.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#show-platform" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
				<li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></li>
				<li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></li>
			</ul>
		</div>
		<div id="show-platform" class="content scaffold-show" role="main">
			<h1><g:message code="default.show.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<ol class="property-list platform">
			
				<g:if test="${platformInstance?.name}">
				<li class="fieldcontain">
					<span id="name-label" class="property-label"><g:message code="platform.name.label" default="Name" /></span>
					
						<span class="property-value" aria-labelledby="name-label"><g:fieldValue bean="${platformInstance}" field="name"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${platformInstance?.comments}">
				<li class="fieldcontain">
					<span id="comments-label" class="property-label"><g:message code="platform.comments.label" default="Comments" /></span>
					
						<span class="property-value" aria-labelledby="comments-label"><g:fieldValue bean="${platformInstance}" field="comments"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${platformInstance?.platformtype}">
				<li class="fieldcontain">
					<span id="platformtype-label" class="property-label"><g:message code="platform.platformtype.label" default="Platformtype" /></span>
					
						<span class="property-value" aria-labelledby="platformtype-label"><g:fieldValue bean="${platformInstance}" field="platformtype"/></span>
					
				</li>
				</g:if>
			
				<g:if test="${platformInstance?.platformversion}">
				<li class="fieldcontain">
					<span id="platformversion-label" class="property-label"><g:message code="platform.platformversion.label" default="Platformversion" /></span>
					
						<span class="property-value" aria-labelledby="platformversion-label"><g:fieldValue bean="${platformInstance}" field="platformversion"/></span>
					
				</li>
				</g:if>
			
			</ol>
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
