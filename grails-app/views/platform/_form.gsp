<%@ page import="org.dbxp.sam.Platform" %>



<div class="fieldcontain ${hasErrors(bean: platformInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="platform.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" required="" value="${platformInstance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: platformInstance, field: 'platformtype', 'error')} ">
	<label for="platformtype">
		<g:message code="platform.platformtype.label" default="Platformtype" />
		
	</label>
	<g:textField name="platformtype" value="${platformInstance?.platformtype}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: platformInstance, field: 'platformversion', 'error')} ">
	<label for="platformversion">
		<g:message code="platform.platformversion.label" default="Platformversion" />
		
	</label>
	<g:textField name="platformversion" value="${platformInstance?.platformversion}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: platformInstance, field: 'comments', 'error')} ">
    <label for="comments">
        <g:message code="platform.comments.label" default="Comments" />

    </label>
    <g:textArea name="name" cols="60" rows="5" maxlength="255" required="" value="${platformInstance?.comments}"/>
</div>
