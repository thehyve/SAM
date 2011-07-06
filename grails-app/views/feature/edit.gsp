<%@ page import="org.dbnp.gdt.TemplateField; org.dbxp.sam.Feature" %>
<%@ page import="org.dbnp.gdt.GdtTagLib" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <g:set var="entityName" value="${message(code: 'feature.label', default: 'Feature')}"/>
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'sam.css')}"/>
        <title><g:message code="default.edit.label" args="[entityName]"/></title>
        <script type="text/javascript">
            $(document).ready(function() {
                new SelectAddMore().init({
                    rel  : 'template',
                    url  : baseUrl + '/templateEditor',
                    vars        : 'entity,ontologies',
                    label   : 'add / modify..',
                    style   : 'modify',
                    onClose : function(scope) {}
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
                    url: "./confirmNewFeatureGroup?newFeatureGroupID="+$("#newFeatureGroup").val()+"&id="+${featureInstance.id},
                    context: document.body,
                    dataType:"json",
                    async: false
                }).responseText;
                $("#featureGroups_list").html(html);
            }
        </script>
    </head>

    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a>
            </span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label"
                                                                                   args="[entityName]"/></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label"
                                                                                       args="[entityName]"/></g:link></span>
        </div>

        <div class="body">
            <h1><g:message code="default.edit.label" args="[entityName]"/></h1>
            <g:hasErrors bean="${featureInstance}">
                <div class="errors">
                    <g:renderErrors bean="${featureInstance}" as="list"/>
                </div>
            </g:hasErrors>
            <g:form class="Feature" action="refreshEdit" name="edit" method="post">
                <%-- <input type="hidden" name="_eventId" value="refreshEdit" /> --%>
                <g:hiddenField name="id" value="${featureInstance?.id}"/>
                <g:hiddenField name="version" value="${featureInstance?.version}"/>
                <div class="dialog">
                    <table>
                        <tbody>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="featureGroups"><g:message code="feature.featureGroups.label" default="Feature Groups"/></label>
                                </td>
                                <td valign="top" class="value" id="featureGroups_list">
                                    <g:each in="${org.dbxp.sam.FeaturesAndGroups.findAllByFeature(featureInstance)}" var="f">
                                        <%-- <li><g:link controller="featureGroup" action="show" id="${f?.featureGroup.id}">${f?.featureGroup.name.encodeAsHTML()}</g:link></li> --%>
                                        <g:form method="post" action="removeGroup">
                                            <g:hiddenField name="fgid" value="${f?.id}"/>
                                            <li>
                                                <g:link controller="featureGroup" action="show" id="${f?.featureGroup.id}">${f?.featureGroup.name.encodeAsHTML()}</g:link>
                                                <span class="buttons">
                                                    <span class="button">
                                                        <g:actionSubmit class="delete" action="removeGroup" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/>
                                                    </span>
                                                </span>
                                            </li>
                                        </g:form>
                                    </g:each>
                                </td>
                            </tr>

                            <tr class="prop">
                                <td valign="top" class="name">
                                    Add this feature to feature group
                                </td>
                                <td valign="top" class="value">
                                    <g:select id="newFeatureGroup" name="newFeatureGroup" from="${org.dbxp.sam.FeatureGroup.list()}" optionKey="id" optionValue="name"/>
                                    <span class="buttons">
                                        <span class="button">
                                            <%-- <button type="button" name="confirmNewFeatureGroup" onclick="confNewFeatGrp();">
                                                Confirm
                                            </button> --%>
                                            <span class="simpleButton">
                                                <a name="confirmNewFeatureGroup" class="buttons button input delete" onclick="confNewFeatGrp();">
                                                    Confirm
                                                </a>
                                            </simpleButton>
                                            <%-- <input type="submit" name="confirmNewFeatureGroup" onclick="confNewFeatGrp();"/> --%>
                                        </span>
                                    </span>
                                </td>
                            </tr>

                            <tr class="prop">
                                <td valign="top" class="name">
                                    Template
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: featureInstance, field: 'template', 'errors')}">
                                    <af:templateElement name="template" rel="template" description="" value="${featureInstance?.template}" error="template" entity="${Feature}" ontologies="${featureInstance.giveDomainFields()}" addDummy="true"
                                                        onChange="if(!\$( 'option:selected', \$(this) ).hasClass( 'modify' )){ submitForm('edit');}">
                                    </af:templateElement>
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">

                                </td>
                                <td valign="top" class="name">
                                    Common fields:
                                </td>
                            </tr>

                            <g:each in="${featureInstance.giveDomainFields()}" var="field">
                                <tr class="prop">
                                    <td valign="top">
                                        ${field}<br/><i>(Required)</i>
                                    </td>
                                    <td valign="top" >
                                        <g:textField name="${field.escapedName()}" value="${featureInstance.getFieldValue(field.toString())}"/>
                                    </td>
                                </tr>
                            </g:each>

                            <tr class="prop">
                                <td/>
                                <td valign="top" class="name">
                                    <br/><br/>Template specific fields:<br/>
                                </td>
                            </tr>

                            <g:if test="${featureInstance.template!=null}">
                                <% def check = featureInstance.getRequiredFields() %>
                                <g:each in="${featureInstance.giveTemplateFields()}" var="field">
                                    <tr class="prop">
                                        <g:if test="${check!=0 && featureInstance.getRequiredFields().contains(field)}">
                                            <td valign="top">
                                                ${field}<br/><i>(Required)</i>
                                            </td>
                                        </g:if>
                                        <g:else>
                                            <td valign="top">
                                                ${field}
                                            </td>
                                        </g:else>
                                        <td valign="top" >
                                            <g:textField name="${field.escapedName()}" value="${featureInstance.getFieldValue(field.toString())}"/>
                                        </td>
                                    </tr>
                                </g:each>
                            </g:if>
                        </tbody>
                    </table>
                </div>

                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" action="update"
                                                         value="${message(code: 'default.button.update.label', default: 'Update')}"/></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete"
                                                         value="${message(code: 'default.button.delete.label', default: 'Delete')}"
                                                         onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
