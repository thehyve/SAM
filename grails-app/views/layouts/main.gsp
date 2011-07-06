<% /* Use the default module layout as a base for our layout */ %>
<g:applyLayout name="module">
	<html>
	    <head>
	        <title><g:layoutTitle default="" /> | Simple Assay Module | dbXP</title>
	        <g:layoutHead />
            <script type="text/javascript" src="${resource(dir: 'js', file: 'SelectAddMore.js', plugin: 'gdt')}"></script>
	    </head>
	    <body>
			<content tag="topnav">
				<% /* Insert only li tags for the top navigation, without surrounding ul */ %>
				<li><a href="${resource(dir: '')}">Home</a></li>
				<li>
					<a href="#" onClick="return false;">Features</a>
					<ul class="subnav">
						<li><g:link controller="feature">List</g:link></li>
						<li><g:link controller="feature" action="create">Create</g:link></li>
						<li><g:link controller="feature" action="import">Import</g:link></li>
                        <li><g:link controller="featureGroup" action="list">Feature groups</g:link></li>
					</ul>
				</li>
				<li>
					<a href="#" onClick="return false;">Measurements</a>
					<ul class="subnav">
						<li><g:link controller="measurement">List</g:link></li>
						<li><g:link controller="measurement" action="create">Create</g:link></li>
						<li><g:link controller="measurement" action="import">Import</g:link></li>
					</ul>
				</li>
				<li>
					<a href="#" onClick="return false;">GSCF</a>
					<ul class="subnav">
						<li><g:link url="${org.codehaus.groovy.grails.commons.ConfigurationHolder.config.gscf.baseURL}">Go to GSCF</g:link></li>
					</ul>
				</li>
			</content>    	
	        <g:layoutBody />
	    </body>
	</html>
</g:applyLayout>