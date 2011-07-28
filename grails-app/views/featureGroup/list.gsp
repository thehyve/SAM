<%@ page import="org.dbxp.sam.FeatureGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>FeatureGroup list</title>
        <r:script type="text/javascript" disposition="head">
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
            <li><g:link class="list" controller="featureGroup">List feature groups</g:link></li>
            <li><g:link class="create" controller="featureGroup" action="create">Create new group</g:link></li>
            <li><g:link class="list" controller="feature" action="list">List features</g:link></li>
        </content>
        <h1>FeatureGroup list</h1>
        <div class="data">
            <dt:dataTable id="fgList" class="paginate sortable filter selectMulti">
                <thead>
                    <tr>

                        <th>Name</th>

                        <th>Does this group contain features?</th>

                        <dt:buttonsHeader numColumns="3"/>

                    </tr>
                </thead>
                <tbody>
                    <g:each in="${featureGroupInstanceList}" status="i" var="featureGroupInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" id="rowid_${featureGroupInstance.id}">

                            <td rowid="${featureGroupInstance.id}">
                                <g:link action="show" id="${featureGroupInstance.id}">${fieldValue(bean: featureGroupInstance, field: "name")}</g:link>
                            </td>

                            <td>
                                <%
                                    def a = org.dbxp.sam.FeaturesAndGroups.findAllByFeatureGroup(featureGroupInstance)
                                    def b = ""
                                    if(a!=null && a.size()>0){
                                        if(a.size()>1){
                                            b = "Yes, it contains "+a.size()+" features."
                                        } else {
                                            b = "Yes, it contains a feature."
                                        }
                                    } else {
                                        b = "No, it does not contain features."
                                    }
                                %>
                                ${b}
                            </td>

                            <dt:buttonsShowEditDelete controller="featureGroup" id="${featureGroupInstance.id}"/>

                        </tr>
                    </g:each>
                </tbody>
            </dt:dataTable>
            <br />
            <ul class="data_nav buttons">
                    <li><a href="#" class="delete" onclick="if(confirm('Are you sure?')) {submitPaginatedForm('fgList','delete', 'No rows selected');} else {return false;}">Delete all marked groups</a></li>
            </ul>
        </div>
    </body>
</html>