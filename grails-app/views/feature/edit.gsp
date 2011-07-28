<%@ page import="org.dbnp.gdt.TemplateField; org.dbxp.sam.Feature" %>
<%@ page import="org.dbnp.gdt.GdtTagLib" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Edit feature ${featureInstance.name}</title>
        <r:script type="text/javascript" disposition="head">
            $(document).ready(function() {
                new SelectAddMore().init({
                    rel  : 'template',
                    url  : baseUrl + '/templateEditor',
                    vars        : 'entity,ontologies',
                    label   : 'add / modify',
                    style   : 'modify',
                    onClose : function(scope) {
                        handleTemplateChange('edit');
                    }
                });
            });

            function handleTemplateChange(id){
                $( 'form#' + id ).submit();
            }

            function addToFeatureGroup(){
                // Add the new feature group in a function apart from the refreshEdit controller action,
                // to make sure feature groups will not be added by accident during a regular refreshEdit call.
                $.ajax({
                    url: baseUrl+"/feature/confirmNewFeatureGroup?newFeatureGroupID="+$("#newFeatureGroup").val()+"&id=${featureInstance.id}",
                    success: function(html, textStatus, jqXHR) {
                    	$("#featureGroups_list").replaceWith(html);
                    }
                });
            }

            function removeFromFeatureGroup( fagId ){
                // Add the new feature group in a function apart from the refreshEdit controller action,
                // to make sure feature groups will not be added by accident during a regular refreshEdit call.
                $.ajax({
                    url: baseUrl+"/feature/removeFromGroup?fagId="+fagId+"&id=${featureInstance.id}",
                    type: "POST",
                    success: function(html, textStatus, jqXHR) {
                    	$("#featureGroups_list").replaceWith(html);
                    }
                });
            }            
            
        </r:script>
    </head>

    <body>
        <g:hasErrors bean="${featureInstance}">
            <div class="errors">
                <g:renderErrors bean="${featureInstance}" as="list"/>
            </div>
        </g:hasErrors>
        <content tag="contextmenu">
            <li><g:link class="list" controller="feature">List features</g:link></li>
            <li><g:link class="create" controller="feature" action="create">Create new feature</g:link></li>
            <li><g:link class="import" controller="feature" action="import">Import</g:link></li>
            <li><g:link class="list" controller="featureGroup">List feature groups</g:link></li>
        </content>
        <h1>Edit feature ${featureInstance.name}</h1>

        <div class="data">
            <g:form class="Feature" action="refreshEdit" name="edit" method="post">
                <%-- <input type="hidden" name="_eventId" value="refreshEdit" /> --%>
                <g:hiddenField name="id" value="${featureInstance?.id}"/>
                <g:hiddenField name="version" value="${featureInstance?.version}"/>
                <div class="dialog">
                    <table>
                        <tr class="prop">
                            <td valign="top">
                                Common fields:
                            </td>
                            <td valign="top" style="width: 40%;">
                                Groups containing this feature:
                            </td>
                        </tr>

                        <%--
                         List common fields on the left, and all feature group items on the right
                         Do this with two tables so that the length of the lists don't mess up the other list's layout.
                         --%>
                         <tr>
                            <td>
                                <table>
                                    <g:each in="${featureInstance.giveDomainFields()}" var="field" status="i">
                                        <tr class="prop ${(i % 2) == 0 ? 'odd' : 'even'}">
                                            <td valign="top">
                                                ${field.name.capitalize()}
                                                <g:if test="${field.required}">
                                                    <i>(required)</i>
                                                </g:if>
                                            </td>
                                            <td valign="top" >
                                                <g:textField name="${field.escapedName()}" value="${featureInstance.getFieldValue(field.toString())}"/>
                                            </td>
                                        </tr>
                                    </g:each>
									<tr class="prop ${(featureInstance.giveDomainFields().size() % 2) == 0 ? 'odd' : 'even'}">
										<td>Template</td>
			                            <td id="templateSelection">
			                                <%-- Unfortunately this gives problems with the template editor
			                                <g:include action="templateSelection" params="['id' : featureInstance.id]"/> --%>
			                                <af:templateElement name="template" rel="template" description="" value="${featureInstance?.template}" error="template" entity="${Feature}" ontologies="${featureInstance.giveDomainFields()}" addDummy="true" onChange="if(!\$( 'option:selected', \$(this) ).hasClass( 'modify' )){ handleTemplateChange('edit');}"></af:templateElement>
			                            </td>
			                           </tr>                                    
                                </table>
                            </td>
                            <td rowspan="3" style="width: 40%;">
                               	<g:include action="confirmNewFeatureGroup" params="['id' : featureInstance.id]" />
                            </td>
                        </tr>

                        <%--
                         End of 'common fields' and 'feature groups' tables
                        --%>

                        <tr class="prop">
                            <td>
                                <g:if test="${featureInstance.template!=null}">
                                    Template specific fields:
                                </g:if>
                            </td>
                        </tr>
                        
                        <tr class="prop">
                            <td id="templateSpecific">
                                <g:include action="templateSpecific" params="['id' : featureInstance.id]"/>
                            </td>
                        </tr>

                    </table>
                </div>

                <ul class="data_nav buttons">
                    <li><g:actionSubmit class="save" action="update" value="Update"/></li>
                    <li><g:actionSubmit class="delete" action="delete" value="Delete" onclick="return confirm('Are you sure?');"/></li>
                    <li><g:link controller="feature" action="list" class="cancel">Cancel</g:link></li>
                </ul>
            </g:form>
        </div>
    </body>
</html>