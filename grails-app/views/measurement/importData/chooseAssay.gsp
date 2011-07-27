<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Measurement importer</title>
        <script type="text/javascript">
            $(document).ready(function() {
                $('#aList').dataTable();
            } );
        </script>
    </head>
    <body>
        <content tag="contextmenu">
            <li><g:link class="list" controller="measurement">List measurements</g:link></li>
            <li><g:link class="create" controller="measurement" action="create">Create new measurement</g:link></li>
            <li><g:link class="import" controller="measurement" action="importData">Import</g:link></li>
        </content>
        <div class="data">
            <h1>Choose the assay</h1>
            <p>The data you wish to import must be related to an assay. Choose the assay in question from the following list. </p>
            <div class="list">
                <dt:dataTable id="fList" class="paginate sortable filter selectOne" rel="${g.createLink( controller: 'feature', action: 'datatables_list' )}">
                    <thead>
                    <tr>
                        <th>Assay</th>
                        <th>Study</th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${assayList}" status="i" var="assayInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" id="rowid_${assayInstance.key}" onclick="$('#assay').val('${assayInstance.key}');$('#study').val('${studyList.get(assayInstance.key)}'); $('#_eventId_next').removeAttr('disabled'); return false;">
                            <td>
                                ${assayInstance.value}
                            </td>
                            <td>
                                ${studyList.get(assayInstance.key)}
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </dt:dataTable>
            </div>
            <g:form method="post" name="importData" action="importData">
                <g:if test="${assay!=null && studyName!=null}">
                    <g:hiddenField name="assay" value="${assay.assayToken}"/>
                    <g:hiddenField name="study" value="${studyName}"/>
                    <g:submitButton name="next" value="Next" action="next"/>
                </g:if>
                <g:else>
                    <g:hiddenField name="assay" value=""/>
                    <g:hiddenField name="study" value=""/>
                    <g:submitButton name="next" value="Next" action="next" disabled='true'/>
                </g:else>
            </g:form>
        </div>
    </body>
</html>