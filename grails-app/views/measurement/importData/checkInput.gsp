<%@ page import="org.dbxp.moduleBase.Study; org.dbxp.moduleBase.Assay" %>
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
            <h1>Confirm input</h1>
            <p>
                Please check your input. Use the 'Previous' button to make changes when necessary.
            </p>
            <form method="post">
                <table>
                    <g:each in="${edited_text}" var="row" status="i">
                        <g:if test="${row.size()==0}">
                            <tr></tr>
                        </g:if>
                        <g:else>
                            <tr>
                                <g:each in="${row}" var="column" status="j">
                                    <g:if test="${!(i==0&j==0)}">
                                        <td  style="border: 1px solid lightgray;">${column}</td>
                                    </g:if>
                                    <g:else>
                                        <td></td>
                                    </g:else>
                                </g:each>
                            </tr>
                        </g:else>
                    </g:each>
                </table>
                <g:submitButton name="previous" value="Previous" action="previous"/>
                <g:submitButton name="save" value="Save your data" action="save"/>
            </form>
        </div>
    </body>
</html>