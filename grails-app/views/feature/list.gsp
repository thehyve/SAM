<%@ page import="org.dbnp.gdt.Template; org.dbxp.sam.Feature" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="sammain"/>
        <title>Feature list</title>
    </head>

    <body>
      	<content tag="contextmenu">
      		<g:render template="contextmenu" />
        </content>
        <h1>Feature list</h1>

        <div class="data">
            <dt:dataTable id="fList" class="paginate sortable filter selectMulti serverside" rel="${g.createLink( controller: 'feature', action: 'datatables_list' )}">
                <thead>
                    <tr>

                        <th>Name</th>

                        <th>Unit</th>

                        <th>Template</th>

                        <dt:buttonsHeader/>

                    </tr>
                </thead>
            </dt:dataTable>
            <br />
            <ul class="data_nav buttons">
                    <li><a href="#" class="delete" onclick="if(confirm('Are you sure?')) {submitPaginatedForm('fList','delete', 'No rows selected');} else {return false;}">Delete all marked features</a></li>
            </ul>
        </div>
    </body>
</html>
