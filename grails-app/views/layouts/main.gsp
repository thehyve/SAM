<% /* Use the default module layout as a base for our layout */ %>
<g:applyLayout name="module">
	<html>
	    <head>
	        <title><g:layoutTitle default="" /> | Simple Assay Module | dbXP</title>
	        <g:layoutHead />
            <script type="text/javascript" src="${resource(dir: 'js', file: 'SelectAddMore.js', plugin: 'gdt')}"></script>
            <script type="text/javascript" src="${resource(dir: 'js', file: 'removeWebFlowExecutionKey.js')}"></script>
            <link rel="stylesheet" href="${resource(dir: 'css', file: 'sam.css')}"/>
	    </head>
	    <body>
			<content tag="topnav">
				<% /* Insert only li tags for the top navigation, without surrounding ul */ %>
				<li><a href="${resource(dir: '')}">Home</a></li>
				<li><g:link controller="feature">Features</g:link></li>
    			<li><g:link controller="measurement">Measurements</g:link></li>
				<li><g:link url="${org.codehaus.groovy.grails.commons.ConfigurationHolder.config.gscf.baseURL}">Go to GSCF</g:link></li>
			</content>
			<div id="contextmenu" class="buttons">
				<ul>
					<g:pageProperty name="page.contextmenu" />
				</ul>					
			</div>
			
			<g:if test="${flash.message}">
				<p class="message">${flash.message.toString()}</p>
			</g:if>
			<g:if test="${flash.error}">
				<p class="error">${flash.error.toString()}</p>
			</g:if>
							
	        <g:layoutBody />
	    </body>
	</html>
</g:applyLayout>
