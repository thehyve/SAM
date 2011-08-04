<%@ page import="org.dbnp.gdt.TemplateField; org.dbxp.sam.Feature" %>
<%@ page import="org.dbnp.gdt.GdtTagLib" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Edit feature ${featureInstance.name}</title>
        <r:script type="text/javascript" disposition="head">
            $(document).ready(function() {
            	insertSelectAddMore();
            });
            
            function insertSelectAddMore() {
                new SelectAddMore().init({
                    rel  : 'template',
                    url  : baseUrl + '/templateEditor',
                    vars        : 'entity,ontologies',
                    label   : 'add / modify',
                    style   : 'modify',
                    onClose : function(scope) {
                        handleTemplateChange();
                    }
                });
            }

            function handleTemplateChange( selectedOption ){
                templateEditorHasBeenOpened = false
                
                if( selectedOption == undefined ) {
	                // If no selectedOptions is given, the template editor has been opened. In that case, we use
	                // the template previously selected
                	templateEditorHasBeenOpened = true;
                } else if( $(selectedOption).hasClass( 'modify' ) ){
                	// If the user has selected the add/modify option, the form shouldn't be updated yet.
                	// That should only happen if the template editor is closed
                	return;
                }
                
                // Collect all data to be sent to the controller
                data = $( "form#edit" ).serialize() + "&templateEditorHasBeenOpened=" + ( templateEditorHasBeenOpened ? "true" : "false" );
                
	            // Always update the template specific fields, when the template has changed but also
	            // when the template editor is closed
                $.ajax({
					url: baseUrl + "/feature/returnUpdatedTemplateSpecificFields",              	
					data: data,
					type: "POST",
					success: function( returnHTML, textStatus, jqXHR ) {
						$( "#templateSpecific" ).html( returnHTML );
												
		                // Update the template select only if the template has been closed
		                // This can only happen after the previous call has succeeded, because 
		                // otherwise Hibernate will show up with a 'collection associated with 
		                // two open sessions' error. 
		                if( templateEditorHasBeenOpened ) {
			                $.ajax({
								url: baseUrl + "/feature/templateSelection",
								data: data,
								type: "POST",
								success: function( returnHTML, textStatus, jqXHR ) {
									$( "td#templateSelection" ).html( returnHTML );
									insertSelectAddMore();
								}          	
			                });
			            }
						
					}          	
                });
	            
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
            <li><g:link class="import" controller="feature" action="importData">Import</g:link></li>
            <li><g:link class="list" controller="featureGroup">List feature groups</g:link></li>
        </content>
        <h1>Edit feature ${featureInstance.name}</h1>

        <div class="data">
            <g:form class="Feature" action="update" name="edit" method="post">
                <g:hiddenField name="id" value="${featureInstance?.id}"/>
                <g:hiddenField name="ids" value="${featureInstance?.id}"/>
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
                                            <td valign="top" class='fieldName'>
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
			                            	<g:render template="templateSelection" model="['template' : featureInstance.template]" />
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
                            	<% 
									def values = [:];
									featureInstance.template?.fields.each {
										values[ it.name ] = featureInstance.getFieldValue( it.name )
									}
								%>
                            	<g:render template="templateSpecific" model="['template': featureInstance.template, values: values ]" />
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