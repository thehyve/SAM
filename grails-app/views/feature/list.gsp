<%@ page import="org.dbxp.sam.FeaturesAndGroups; org.dbnp.gdt.Template; org.dbxp.sam.Feature" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>Feature list</title>
        <r:script type="text/javascript" disposition="head">
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
        </r:script>
    </head>

    <body>
      	<content tag="contextmenu">
            <li><g:link class="list" controller="feature">List features</g:link></li>
            <li><g:link class="create" controller="feature" action="create">Create new feature</g:link></li>
            <li><g:link class="import" controller="feature" action="import">Import</g:link></li>
            <li><g:link class="list" controller="featureGroup">List feature groups</g:link></li>
        </content>
        <h1>Feature list</h1>

        <div class="data">
            <dt:dataTable id="fList" class="paginate sortable filter selectMulti serverside" rel="${g.createLink( controller: 'feature', action: 'datatables_list' )}">
                <thead>
                    <tr>

                        <th>Name</th>

                        <th>Unit</th>

                        <th class="nonsortable">Groups</th>

                        <dt:buttonsHeader/>

                    </tr>
                </thead>
                <!-- 
                <tbody>
                    <g:each in="${featureInstanceList}" status="i" var="featureInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" id="rowid_${featureInstance.id}">

                            <td>
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

                            <dt:buttonsShowEditDelete controller="feature" id="${featureInstance.id}"/>

                        </tr>
                    </g:each>
                </tbody>
                 -->
            </dt:dataTable>
            <br />
            <ul class="data_nav buttons">
                    <li><a href="#" class="delete" onclick="if(confirm('Are you sure?')) {submitPaginatedForm('fList','delete', 'No rows selected');} else {return false;}">Delete all marked features</a></li>
            </ul>
        </div>
    </body>
</html>
