
<%@ page import="org.dbxp.moduleBase.Study" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <title>Assays</title>
    </head>
    <body>
        <h1>Assay list</h1>

        <div class="data">
            <dt:dataTable id="fList" class="paginate sortable filter selectMulti serverside" rel="${g.createLink( controller: 'assay', action: 'datatables_list' )}">
                <thead>
                    <tr>

                        <th>Study</th>

                        <th>Assay</th>

                        <th># Samples</th>
						
						<th class="nonsortable"></th>
                    </tr>
                </thead>
            </dt:dataTable>
        </div>
    </body>
</html>
