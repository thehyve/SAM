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
            <h1>The importing process has finished.</h1>
            <p>Your data has been successfully imported and is available now. It can be seen on the <g:link controller="assay" action="show" id="${assay.id}">${assay.name}</g:link> overview page. If you wish to add more data you can do so <g:link controller="measurement" action="importData">by clicking here</g:link>.</p>
            <g:if test="${message}">
				<p class="message">${message.toString()}</p>
			</g:if>
			<g:if test="${error}">
				<p class="error">${error.toString()}</p>
			</g:if>
        </div>
    </body>
</html>