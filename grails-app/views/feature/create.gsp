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
            <g:form action="save">
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
                    <li><g:submitButton name="create" class="save" value="Create"/></li>
                    <li><g:link controller="feature" action="list" class="cancel">Cancel</g:link></li>
                </ul>
            </g:form>
        </div>
    </body>
</html>
