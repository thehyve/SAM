<html>
    <head>
      <meta name="layout" content="main"/>
      <title>Feature importer</title>
        
        <r:require module="importer" />
      
    </head>
    <body>
        <content tag="contextmenu">
            <li><g:link class="list" controller="feature">List features</g:link></li>
            <li><g:link class="create" controller="feature" action="create">Create new feature</g:link></li>
            <li><g:link class="import" controller="feature" action="importData">Import</g:link></li>
            <li><g:link class="list" controller="featureGroup">List feature groups</g:link></li>
        </content>
        <div class="data">

            <imp:importerHeader pages="${pages}" page="saveData" />

            <h1>The importing process has finished.</h1>
            <p>The new features should now be available.</p>
            <g:if test="${message}">
				<p class="message">${message.toString()}</p>
			</g:if>
			<g:if test="${error}">
				<p class="error">${error.toString()}</p>
			</g:if>
        </div>
    </body>
</html>