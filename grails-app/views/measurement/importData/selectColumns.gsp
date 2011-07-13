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
            <h1>Choose columns</h1>
            <p></p>
            <g:form method="post" name="importData" action="importData">
                <g:hiddenField name="assay" value=""/>
                <g:hiddenField name="study" value=""/>
                <g:submitButton name="next" value="next">Next</g:submitButton>
            </g:form>
        </div>
    </body>
</html>