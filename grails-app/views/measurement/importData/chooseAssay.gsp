<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Measurement importer</title>
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
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}" id="rowid_${assayInstance.id}">
                            <td>
                                ${assayInstance.name}
                            </td>
                            <td>
                                ${assayInstance.study.name}
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </dt:dataTable>
            </div>
            <g:form method="post" name="importData" action="importData">
            	<%-- 
            		If an assay has been selected before, and the user returns here, we don't select that assay. That has two reasons:
            		- the datatables scripts don't support a checkbox or radio being selected on load
            		- the user does want to select another assay, so the current selection is not important
            	 --%>
				<g:hiddenField name="assay" value=""/>
				<g:submitButton name="next" value="Next" action="next" onClick="
					if( elementsSelected == undefined || elementsSelected[ 'fList_table' ] == undefined || elementsSelected[ 'fList_table' ].length == 0 ) {
						return false;
					} else {
						\$( '#assay' ).val( elementsSelected[ 'fList_table' ][ 0] );
						return true;
					}
				"/>
            </g:form>
        </div>
    </body>
</html>