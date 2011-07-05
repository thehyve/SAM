<%@ page import="org.dbnp.gdt.TemplateField; org.dbxp.sam.Feature" %>
<%@ page import="org.dbnp.gdt.GdtTagLib" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>

        <g:set var="entityName" value="${message(code: 'feature.label', default: 'Feature')}"/>
        <title><g:message code="default.edit.label" args="[entityName]"/></title>
        <script>
            $(document).ready(function() {
                $('#test-div').html("Available feature templates: ${Feature.list().template}");
                //alert("Did it werk? Also, "+$('#test-div').html());
                new SelectAddMore().init({
                    rel	 : 'template',
                    url	 : baseUrl + '/templateEditor',
                    vars	: 'entity,ontologies',
                    label   : 'add / modify..',
                    style   : 'modify',
                    onClose : function(scope) {
                        refreshTemplateSelect();
                    }
                });
            });

            function refreshTemplateSelect() {
                $("input[type*='text']").each(function() {
                    alert(this.value);
                });
            }

            function updateFields(e) {
                <%-- $("input[type*='text']").each(
                        function() {
                            if(this.name.toString()==tmp[0]){
                                alert("Yes, "+this.name+" "+tmp[0]);
                                this.val(tmp[0]);
                            }
                        }
                ); --%>

            }

            function updaaateFields(id, fields) {
                var html = $.ajax({
	                url: "./ajaxGetFields?id="+id,
	                context: document.body,
                    dataType:"json",
                    async: false
    	        }).responseText;

                var html3 = $.parseJSON(html);

                for(var i = 0; i < html3.length; i++){
                    var tmp = html3[i].toString().split(' : ');
                    //$("[name*='"+tmp[0]+"']").val(tmp[1].toString());
                    var contains = false;
                    for(var j = 0; j < fields.length; j++){
                        alert(fields[j].name);
                        if(fields[j].name==tmp[0]){
                            contains = true;
                        } else {
                        }
                    }
                    if(!contains){
                        alert(tmp[0]+" kan niet gevonden worden. ");
                    }
                }
                <%-- $("input[type*='text']").each(function() {
                    alert(this.value);
                }); --%>
            }


            function submitForm(id, action) {
                var form = $( 'form#' + id );

                if( action != undefined ) {
                    $( 'input[name=event]', form ).val( action );
                    $( 'input[name=_eventId]', form ).val( action );
                }

                form.submit();
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
            <g:if test="${flash.message}">
                <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${featureInstance}">
                <div class="errors">
                    <g:renderErrors bean="${featureInstance}" as="list"/>
                </div>it.escapedName()
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
                                <td valign="top" class="name">
                                    <label for="featureGroups"><g:message code="feature.featureGroups.label"
                                                                          default="Feature Groups"/></label>
                                </td>
                                <td valign="top"
                                    class="value ${hasErrors(bean: featureInstance, field: 'featureGroups', 'errors')}">

                                </td>
                            </tr>

                            <%--
                            <tr class="prop">
                                <td valign="top" class="name">
                                    Template
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: featureInstance, field: 'template', 'errors')}">

                                    <af:templateElement name="template_oud" rel="template" description="" value="${featureInstance?.template}" error="template" entity="${Feature}" ontologies="${featureInstance.giveDomainFields()}" addDummy="true" onChange="updaaateFields(${featureInstance?.id}, ${featureInstance.giveFields().name})">
                                    </af:templateElement>
                                </td>
                            </tr>
                            --%>

                            <tr class="prop">
                                <td valign="top" class="name">
                                    Template nieuw
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: featureInstance, field: 'template', 'errors')}">
                                    <%-- <af:templateElement name="template" rel="template" description="with template" value="${featureInstance?.template}" error="template" entity="${Feature}" ontologies="${featureInstance.giveDomainFields()}" addDummy="true" onChange="${remoteFunction(controller:'feature',action:'ajaxGetFields',params:'\'id=\'+escape(this.value)',onComplete:'updateFields(e)')}">
                                        The template to use for this feature.
                                    </af:templateElement> --%>
                                    <af:templateElement name="template" rel="template" description="" value="${featureInstance?.template}" error="template" entity="${Feature}" ontologies="${featureInstance.giveDomainFields()}" addDummy="true" onChange="submitForm('edit');">
                                    </af:templateElement>
                                </td>
                            </tr>

                            <tr class="prop">
                                <td valign="top" class="name">
 ${featureInstance.giveTemplateFields().name}
                                </td>
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
