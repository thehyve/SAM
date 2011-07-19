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
            <li><g:link class="list" controller="feature">List features</g:link></li>
            <li><g:link class="create" controller="feature" action="create">Create new feature</g:link></li>
            <li><g:link class="import" controller="feature" action="import">Import</g:link></li>
            <li><g:link class="list" controller="featureGroup">List feature groups</g:link></li>
        </content>
        <h1><g:message code="default.list.label" args="[entityName]"/></h1>

        <div class="data">
            <g:dataTable id="fList" class="paginate sortable filter selectMulti">
                <thead>
                    <tr>

                        <th>Name</th>

                        <th>Unit</th>

                        <th>Groups</th>

                        <g:buttonsHeader/>

                    </tr>
                </thead>
                <tbody>
                    <g:each in="${featureInstanceList}" status="i" var="featureInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                            <td rowid="${featureInstance.id}">
                                <g:link action="show" id="${featureInstance.id}">${fieldValue(bean: featureInstance, field: "name")}</g:link>
                            </td>

                            <td>${fieldValue(bean: featureInstance, field: "unit")}</td>

                            <td>
                                <g:each in="${FeaturesAndGroups.findAllByFeature(featureInstance)}" var="g">
                                    <g:link action="show" controller="featuresAndGroups"
                                        id="${g.id}">${fieldValue(bean: g.featureGroup, field: "name")}</g:link>
                                    <br/>
                                </g:each>
                            </td>

                            <g:buttonsViewEditDelete controller="feature" id="${featureInstance.id}"/>

                        </tr>
                    </g:each>
                </tbody>
            </g:dataTable>
            <br />
            <ul class="data_nav buttons">
                    <li><a href="#" class="delete" onclick="submitForm('deleteMultiple', ''); return false;">Delete all marked features</a></li>
            </ul>
        </div>
    </body>
</html>
