<%@ page import="org.dbxp.sam.Feature" %>



<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'UUID', 'error')} ">
	<label for="UUID">
		<g:message code="feature.UUID.label" default="UUID" />
		
	</label>
	<g:textArea name="UUID" cols="40" rows="5" maxlength="255" value="${featureInstance?.UUID}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'template', 'error')} ">
	<label for="template">
		<g:message code="feature.template.label" default="Template" />
		
	</label>
	<g:select id="template" name="template.id" from="${org.dbnp.gdt.Template.list()}" optionKey="id" value="${featureInstance?.template?.id}" class="many-to-one" noSelection="['null': '']"/>
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'templateBooleanFields', 'error')} ">
	<label for="templateBooleanFields">
		<g:message code="feature.templateBooleanFields.label" default="Template Boolean Fields" />
		
	</label>
	
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'templateDateFields', 'error')} ">
	<label for="templateDateFields">
		<g:message code="feature.templateDateFields.label" default="Template Date Fields" />
		
	</label>
	
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'templateDoubleFields', 'error')} ">
	<label for="templateDoubleFields">
		<g:message code="feature.templateDoubleFields.label" default="Template Double Fields" />
		
	</label>
	
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'templateExtendableStringListFields', 'error')} ">
	<label for="templateExtendableStringListFields">
		<g:message code="feature.templateExtendableStringListFields.label" default="Template Extendable String List Fields" />
		
	</label>
	<g:select name="templateExtendableStringListFields" from="${org.dbnp.gdt.TemplateFieldListItem.list()}" multiple="multiple" optionKey="id" size="5" value="${featureInstance?.templateExtendableStringListFields*.id}" class="many-to-many"/>
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'templateFileFields', 'error')} ">
	<label for="templateFileFields">
		<g:message code="feature.templateFileFields.label" default="Template File Fields" />
		
	</label>
	
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'templateLongFields', 'error')} ">
	<label for="templateLongFields">
		<g:message code="feature.templateLongFields.label" default="Template Long Fields" />
		
	</label>
	
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'templateModuleFields', 'error')} ">
	<label for="templateModuleFields">
		<g:message code="feature.templateModuleFields.label" default="Template Module Fields" />
		
	</label>
	<g:select name="templateModuleFields" from="${org.dbnp.gdt.AssayModule.list()}" multiple="multiple" optionKey="id" size="5" value="${featureInstance?.templateModuleFields*.id}" class="many-to-many"/>
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'templateTermFields', 'error')} ">
	<label for="templateTermFields">
		<g:message code="feature.templateTermFields.label" default="Template Term Fields" />
		
	</label>
	<g:select name="templateTermFields" from="${org.dbnp.gdt.Term.list()}" multiple="multiple" optionKey="id" size="5" value="${featureInstance?.templateTermFields*.id}" class="many-to-many"/>
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'templateRelTimeFields', 'error')} ">
	<label for="templateRelTimeFields">
		<g:message code="feature.templateRelTimeFields.label" default="Template Rel Time Fields" />
		
	</label>
	
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'templateStringFields', 'error')} ">
	<label for="templateStringFields">
		<g:message code="feature.templateStringFields.label" default="Template String Fields" />
		
	</label>
	
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'templateStringListFields', 'error')} ">
	<label for="templateStringListFields">
		<g:message code="feature.templateStringListFields.label" default="Template String List Fields" />
		
	</label>
	<g:select name="templateStringListFields" from="${org.dbnp.gdt.TemplateFieldListItem.list()}" multiple="multiple" optionKey="id" size="5" value="${featureInstance?.templateStringListFields*.id}" class="many-to-many"/>
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'templateTemplateFields', 'error')} ">
	<label for="templateTemplateFields">
		<g:message code="feature.templateTemplateFields.label" default="Template Template Fields" />
		
	</label>
	<g:select name="templateTemplateFields" from="${org.dbnp.gdt.Template.list()}" multiple="multiple" optionKey="id" size="5" value="${featureInstance?.templateTemplateFields*.id}" class="many-to-many"/>
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'templateTextFields', 'error')} ">
	<label for="templateTextFields">
		<g:message code="feature.templateTextFields.label" default="Template Text Fields" />
		
	</label>
	
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'name', 'error')} required">
	<label for="name">
		<g:message code="feature.name.label" default="Name" />
		<span class="required-indicator">*</span>
	</label>
	<g:textField name="name" required="" value="${featureInstance?.name}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'unit', 'error')} ">
	<label for="unit">
		<g:message code="feature.unit.label" default="Unit" />
		
	</label>
	<g:textField name="unit" value="${featureInstance?.unit}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: featureInstance, field: 'platform', 'error')} required">
	<label for="platform">
		<g:message code="feature.platform.label" default="Platform" />
		<span class="required-indicator">*</span>
	</label>
	<g:select id="platform" name="platform.id" from="${org.dbxp.sam.Platform.list()}" optionKey="id" required="" value="${featureInstance?.platform?.id}" class="many-to-one"/>
</div>

