<%@ page import="org.dbxp.sam.FeaturesAndGroups; org.dbnp.gdt.Template; org.dbxp.sam.Feature" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <g:set var="entityName" value="${message(code: 'feature.label', default: 'Feature')}"/>
        <title><g:message code="default.list.label" args="[entityName]"/></title>
        <script type="text/javascript">
            $(document).ready(function() {
                $('#fList').dataTable();
            } );

            function deleteItems(){
                var selected_boxes = $("input[@name=fgMassDelete]:checked");
                var num = selected_boxes.length;
                var values = $(selected_boxes).val();
                alert(num,+", "+values);
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
      	<content tag="contextmenu">
            <li><g:link controller="feature">List features</g:link></li>
            <li><g:link controller="feature" action="create">Create new feature</g:link></li>
            <li><g:link controller="featureGroup">List feature groups</g:link></li>
        </content>
        <h1><g:message code="default.list.label" args="[entityName]"/></h1>

        <div class="data">
            <g:form name="deleteMultiple" action="deleteMultiple">
                <div class="list">
                    <table id="fList" class="datatables paginate sortable filter">
                        <thead>
                        <tr>

                            <th>Name</th>

                            <th>Unit</th>

                            <th>Groups</th>

                            <th class="nonsortable">Mark for deletion</th>

                        </tr>
                        </thead>
                        <tbody>
                        <g:each in="${featureInstanceList}" status="i" var="featureInstance">
                            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                                <td><g:link action="show"
                                            id="${featureInstance.id}">${fieldValue(bean: featureInstance, field: "name")}</g:link></td>

                                <td>${fieldValue(bean: featureInstance, field: "unit")}</td>

                                <td>
                                    <g:each in="${FeaturesAndGroups.findAllByFeature(featureInstance)}" var="g">
                                        <g:link action="show" controller="featuresAndGroups"
                                            id="${g.id}">${fieldValue(bean: g.featureGroup, field: "name")}</g:link>
                                        <br/>
                                    </g:each>
                                </td>

                                <td>
                                    <input type="checkbox" name="fMassDelete" value="${featureInstance.id}"/>
                                </td>

                            </tr>
                        </g:each>
                        </tbody>
                    </table>
                </div>
                <ul class="data_nav buttons">
                    <li><g:link controller="feature" action="create" class="create">Add</g:link></li>
                    <li><a class="delete handmadeButton" onclick="submitForm('deleteMultiple', '');">Delete all marked features</a></li>
                </ul>
            </g:form>
        </div>
    </body>
</html>
