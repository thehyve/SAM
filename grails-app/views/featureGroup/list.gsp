<%@ page import="org.dbxp.sam.FeatureGroup" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <g:set var="entityName" value="${message(code: 'featureGroup.label', default: 'FeatureGroup')}"/>
        <title><g:message code="default.list.label" args="[entityName]"/></title>
        <script type="text/javascript">
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
            <li><g:link class="list" controller="featureGroup">List feature groups</g:link></li>
            <li><g:link class="create" controller="featureGroup" action="create">Create new group</g:link></li>
            <li><g:link class="list" controller="feature" action="list">List features</g:link></li>
        </content>
        <h1><g:message code="default.list.label" args="[entityName]"/></h1>
        <div class="data">
            <g:dataTable id="fgList" class="paginate sortable filter selectMulti">
                <thead>
                    <tr>

                        <th>${message(code: 'featureGroup.name.label', default: 'Name')}</th>

                        <th>In use</th>

                        <g:buttonsHeader numColumns="3"/>

                    </tr>
                </thead>
                <tbody>
                    <g:each in="${featureGroupInstanceList}" status="i" var="featureGroupInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                            <td rowid="${featureGroupInstance.id}">
                                <g:link action="show" id="${featureGroupInstance.id}">${fieldValue(bean: featureGroupInstance, field: "name")}</g:link>
                            </td>

                            <td>
                                <%
                                    def a = org.dbxp.sam.FeaturesAndGroups.findAllByFeatureGroup(featureGroupInstance)
                                    def b = ""
                                    if(a!=null && a.size()>0){
                                        if(a.size()>1){
                                            b = "Yes, used by "+a.size()+" features"
                                        } else {
                                            b = "Yes, used by one feature"
                                        }
                                    } else {
                                        b = "No, not in use"
                                    }
                                %>
                                ${b}
                            </td>

                            <g:buttonsViewEditDelete controller="featureGroup" id="${featureGroupInstance.id}"/>

                        </tr>
                    </g:each>
                </tbody>
            </g:dataTable>
            <br />
            <ul class="data_nav buttons">
                <li><a class="delete handmadeButton" onclick="submitForm('deleteMultiple', '');">Delete all marked groups</a></li>
            </ul>
        </div>
    </body>
</html>