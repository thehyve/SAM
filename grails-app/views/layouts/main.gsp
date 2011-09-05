<% /* Use the default module layout as a base for our layout */ %>
<g:applyLayout name="module">
	<html>
	    <head>
	        <title><g:layoutTitle default="" /> | Simple Assay Module | dbXP</title>

	        <r:require modules="sam2"/>

	        <g:layoutHead />
	    </head>
	    <body>
			<content tag="topnav">
				<% /* Insert only li tags for the top navigation, without surrounding ul */ %>
				<li><g:link controller="home">Home</g:link></li>
				<li>
					<a href="#">Browse</a>
					<ul class="subnav">
		    			<!-- <li><g:link controller="measurement">Measurements</g:link></li> -->
						<li><g:link controller="feature">Features</g:link></li>
						<!-- <li><g:link controller="featureGroup">Featuregroups</g:link></li> -->
						<li><g:link controller="assay">Assays</g:link></li>
		    		</ul>
		    	</li>
				<li>
					<a href="#">Import</a>
					<ul class="subnav">
						<li><g:link controller="feature" action="importData">Features</g:link></li>
		    			<li><g:link controller="measurement" action="importData">Measurements</g:link></li>
		    		</ul>
		    	</li>
				<li><g:link url="${org.codehaus.groovy.grails.commons.ConfigurationHolder.config.gscf.baseURL}">Go to GSCF</g:link></li>
                <g:if test="${org.codehaus.groovy.grails.commons.ConfigurationHolder.config.module.showVersionInfo}">
                    <li style="font-size: 9px; color: #888;"><g:message code="meta.app.version" default="Version: {0}" args="[meta(name: 'app.version')]"/><br />Changeset: <g:render template="/version"/></li>
                </g:if>
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
