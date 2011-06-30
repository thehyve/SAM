<!DOCTYPE html>
<html>
    <head>
	    <script type="text/javascript">var baseUrl = '${resource(dir: '')}';</script>

        <g:javascript library="jquery" plugin="jquery"/>
		<jqui:resources themeCss="${createLinkTo(dir: 'css/cupertino', file: 'jquery-ui-1.8.13.custom.css')}" />
		
        <script type="text/javascript" src="${resource(dir: 'js', file: 'SelectAddMore.js', plugin: 'gdt')}"></script>
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'templateEditor.css', plugin: 'gdt')}"/>

        <title><g:layoutTitle default="Grails" /></title>
        <link rel="stylesheet" href="${resource(dir:'css',file:'main.css')}" />
        <link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon" />
        
        <g:layoutHead />
        
    </head>
    <body>
        <div id="spinner" class="spinner" style="display:none;">
            <img src="${resource(dir:'images',file:'spinner.gif')}" alt="${message(code:'spinner.alt',default:'Loading...')}" />
        </div>
        <div id="grailsLogo"><a href="http://grails.org"><img src="${resource(dir:'images',file:'grails_logo.png')}" alt="Grails" border="0" /></a></div>
        <g:layoutBody />
    </body>
</html>