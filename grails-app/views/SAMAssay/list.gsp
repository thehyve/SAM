<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="sammain" />
        <title>Assays</title>
    </head>
    <body>
        <h1>Assay list</h1>

        <div class="data">
            <dt:dataTable id="fList" class="paginate sortable filter serverside" rel="${g.createLink( controller: 'SAMAssay', action: 'datatables_list' )}">
                <thead>
                    <tr>

                        <th>Study</th>

                        <th>Assay</th>

                        <th class="nonsortable"># Samples</th>

						<th class="nonsortable"></th>
                    </tr>
                </thead>
            </dt:dataTable>
        </div>
    </body>
</html>
