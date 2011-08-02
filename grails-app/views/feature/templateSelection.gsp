<%@ page import="org.dbxp.sam.Feature" %>
<af:templateElement name="template" rel="template" description="" value="${template}" error="template" entity="${Feature}" ontologies="" addDummy="true" onChange="if(!\$( 'option:selected', \$(this) ).hasClass( 'modify' )){ handleTemplateChange('edit');}" optionKey="id" optionValue="name">
</af:templateElement>