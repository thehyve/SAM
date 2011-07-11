<%@ page import="org.dbnp.gdt.TemplateField; org.dbxp.sam.Feature" %>
<%@ page import="org.dbnp.gdt.GdtTagLib" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <g:set var="entityName" value="${message(code: 'feature.label', default: 'Feature')}"/>
        <title><g:message code="default.edit.label" args="[entityName]"/></title>
        <script type="text/javascript">
            $(document).ready(function() {
                new SelectAddMore().init({
                    rel  : 'template',
                    url  : baseUrl + '/templateEditor',
                    vars        : 'entity,ontologies',
                    label   : 'add / modify..',
                    style   : 'modify',
                    onClose : function(scope) {
                        submitForm('edit');
                    }
                });
            });

            function submitForm(id, action) {
                var form = $( 'form#' + id );

                if( action != undefined ) {
                    $( 'input[name=event]', form ).val( action );
                    $( 'input[name=_eventId]', form ).val( action );
                }

                form.submit();
            }

            function confNewFeatGrp(){
                // Add the new feature group in a function apart from the refreshEdit controller action,
                // to make sure feature groups will not be added by accident during a regular refreshEdit call.
                var html = $.ajax({
                    url: baseUrl+"/feature/confirmNewFeatureGroup?newFeatureGroupID="+$("#newFeatureGroup").val()+"&id="+${featureInstance.id},
                    context: document.body,
                    dataType:"json",
                    async: false
                }).responseText;
                $("#featureGroups_list").html(html);
            }
        </script>
    </head>

    <body>
        <g:hasErrors bean="${featureInstance}">
            <div class="errors">
                <g:renderErrors bean="${featureInstance}" as="list"/>
            </div>
        </g:hasErrors>
        <content tag="contextmenu">
            <li><g:link controller="feature">List features</g:link></li>
            <li><g:link controller="feature" action="create">Create new feature</g:link></li>
            <li><g:link controller="featureGroup">List feature groups</g:link></li>
        </content>
        <h1><g:message code="default.edit.label" args="[entityName]"/></h1>

        <div class="data">
            <g:form class="Feature" action="refreshEdit" name="edit" method="post">
                <%-- <input type="hidden" name="_eventId" value="refreshEdit" /> --%>
                <g:hiddenField name="id" value="${featureInstance?.id}"/>
                <g:hiddenField name="version" value="${featureInstance?.version}"/>
                <div class="dialog">
                    <table>
                        <tr class="prop">
                            <td valign="top" class="name">
                                Common fields:
                            </td>
                            <td valign="top" class="name">
                                Feature group selection:
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
                                                ${field}
                                                <g:if test="${field.required}">
                                                    <i>(required)</i>
                                                </g:if>
                                            </td>
                                            <td valign="top" >
                                                <g:textField name="${field.escapedName()}" value="${featureInstance.getFieldValue(field.toString())}"/>
                                            </td>
                                        </tr>
                                    </g:each>
                                </table>
                            </td>
                            <td>
                                <g:include action="confirmNewFeatureGroup" params="['id' : featureInstance.id]" />
                                <table>
                                    <tr valign="top" class="value">
                                        <td valign="top" class="name">
                                            Add this feature to feature group
                                        </td>
                                        <td>
                                            <g:select id="newFeatureGroup" name="newFeatureGroup" from="${org.dbxp.sam.FeatureGroup.list()}" optionKey="id" optionValue="name"/>
                                            <span class="buttons button simpleButton">
                                                <a name="confirmNewFeatureGroup" class="buttons button input add handmadeButton" onclick="confNewFeatGrp();">
                                                    Confirm addition to this group
                                                </a>
                                            </span>
                                        </td>
                                    </tr>
                                </table>
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
                            <td valign="top" class="name">
                                Template selection:
                            </td>
                        </tr>
                        <tr class="prop">
                            <td>
                                <g:if test="${featureInstance.template!=null}">
                                    <table>
                                        <g:each in="${featureInstance.giveTemplateFields()}" var="field" status="i">
                                            <tr class="prop ${(i % 2) == 0 ? 'odd' : 'even'}">
                                                <td valign="top">
                                                    ${field}
                                                    <g:if test="${field.required}">
                                                        <i>(required)</i>
                                                    </g:if>
                                                </td>
                                                <td valign="top" >
                                                    <g:textField name="${field.escapedName()}" value="${featureInstance.getFieldValue(field.toString())}"/>
                                                </td>
                                            </tr>
                                        </g:each>
                                    </table>
                                </g:if>
                            </td>

                            <td valign="top" class="value ${hasErrors(bean: featureInstance, field: 'template', 'errors')}">
                                <af:templateElement name="template" rel="template" description="" value="${featureInstance?.template}" error="template" entity="${Feature}" ontologies="${featureInstance.giveDomainFields()}" addDummy="true"
                                                    onChange="if(!\$( 'option:selected', \$(this) ).hasClass( 'modify' )){ submitForm('edit');}">
                                </af:templateElement>
                            </td>
                        </tr>


                    </table>
                </div>

                <ul class="data_nav buttons">
                    <li><g:actionSubmit class="save" action="update" value="Update"/></li>
                    <li><g:actionSubmit class="delete" action="delete" value="Delete" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></li>
                    <li><g:link controller="feature" action="list" class="cancel">Cancel</g:link></li>
                </ul>
            </g:form>
        </div>
    </body>
</html>