<html>
    <head>
      <meta name="layout" content="main"/>
      <title>Feature importer</title>
        
        <r:require module="importer" />
      
    </head>
    <body>
        <content tag="contextmenu">
      		<g:render template="contextmenu" />
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