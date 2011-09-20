<%@ page import="org.dbxp.sam.Feature" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Create a new feature</title>
        <r:require module="featureTemplateFields"/>
        <r:script type="text/javascript" disposition="head">
            $(document).ready(function() {
            	insertSelectAddMore();
                onStudyWizardPage(); // Add datepickers
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
                data = $( "form#create" ).serialize() + "&templateEditorHasBeenOpened=" + ( templateEditorHasBeenOpened ? "true" : "false" );

	            // Always update the template specific fields, when the template has changed but also
	            // when the template editor is closed
                $.ajax({
					url: baseUrl + "/feature/returnUpdatedTemplateSpecificFields",
					data: data,
					type: "POST",
					success: function( returnHTML, textStatus, jqXHR ) {
						$( "#templateSpecific" ).html( returnHTML );
                        onStudyWizardPage(); // Add datepickers

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

            function addFeatureGroup(){
                // Add the new feature group to the list
                var optId = $("select#newFeatureGroup option:selected").val();
                var optText = $("select#newFeatureGroup option:selected").text();

                if(optId!="") {
                    var newA = $( '<a>' ).attr("href",baseUrl+"/featureGroup/show/"+optId)
                        .attr("class","showLink")
                        .text(optText);

                    var newDELA = $( '<a>' ).attr("href","#")
                        .attr("class","buttons button delete")
                        .attr("onClick","removeFeatureGroup("+optId+");");

                    var newSPAN = $( '<span>' ).attr("class"," buttons button")
                        .append(newDELA);

                    var newINPUT = $( '<input>' ).attr("type","hidden")
                        .attr("name","featuregroups")
                        .attr("value",optId);

                    var newLI = $( '<li>' ).attr( "id", "fg_"+optId )
                        .css( "display", "none")
                        .css( "background-color", "#FFFF66")
                        .append(newA).append(newSPAN).append(newINPUT);

                    $("ul#fg").append(newLI);

                    $("ul#fg #fg_"+optId).fadeIn( 'slow', function() { $("ul#fg #fg_"+optId).css("background-color",""); } );

                    $("select#newFeatureGroup option:selected").remove();

                    $("#noGroups").css("display","none");
                }
            }

            function removeFeatureGroup( fagId ){
                // Remove the new feature group from the list
                var optText = $("ul#fg #fg_"+fagId+" a").text();
                $("ul#fg #fg_"+fagId).css("background-color","#FF3333");

                $("ul#fg #fg_"+fagId).fadeOut( 'slow', function() {
                    $("ul#fg #fg_"+fagId).remove();
                    if($('ul#fg li').size()==0) {
                        $("#noGroups").css("display","block");
                    }
                });

                $("select#newFeatureGroup").append("<option value="+fagId+">"+optText+"</option>");

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
      		<g:render template="contextmenu" />
        </content>
        <h1>Create a new feature</h1>

        <div class="data">
            <g:form action="save" name="create">
                <input type="hidden" name="nextPage" id="nextPage" value="list" />
                <div class="dialog">
                    <table>
                        <tr class="prop">
                            <td valign="top">
                                Common fields:
                            </td>
                            <td valign="top">
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
                            <td rowspan="3" class="styleFeatureGroup">
                                <div id="noGroups" style="display: ${(groupList==null || groupList.size>0) ? "none" : "block"}"><i>This feature is not present in any groups</i></div>
                                <ul id="fg">
                               	<g:each in="${groupList}" var="f" status="i">
                                    <li id="fg_${f?.featureGroup.id}">
                                        <g:link controller="featureGroup" action="show" id="${f?.featureGroup.id}" class="showLink">${f?.featureGroup.name.encodeAsHTML()}</g:link>
                                        <span class="buttons button">
                                            <a href="#" class="buttons button delete" onclick="removeFeatureGroup(${f?.featureGroup.id});"></a>
                                        </span>
                                        <input type="hidden" name="featuregroups" value="${f?.featureGroup.id}" />
                                    </li>
                                </g:each>
                                </ul>
                                <br />
                                Add this feature to group:
                                <br />
                                <select id="newFeatureGroup" onchange="addFeatureGroup()">
                                    <option value="" SELECTED="true">[select group]</option>
                                    <g:each in="${remainingGroups}" var="f" status="j">
                                        <option value="${f?.id}">${f?.name.encodeAsHTML()}</option>
                                    </g:each>
                                </select>
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
									/*featureInstance.template?.fields.each {
										values[ it.name ] = featureInstance.getFieldValue( it.name )
									}*/
                                    // This feature is brand new. As such, it will not have any template fields set
								%>
                            	<g:render template="templateSpecific" model="['template': featureInstance.template, values: values ]" />
                            </td>
                        </tr>

                    </table>
                </div>
                <ul class="data_nav buttons">
                    <li><g:submitButton name="create" class="save" value="Create"/></li>
                    <li><g:link controller="feature" action="list" class="cancel">Cancel</g:link></li>
                </ul>
            </g:form>
        </div>
    </body>
</html>
