<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <title>You have no features</title>
    </head>

    <body>
        <content tag="contextmenu">
            <li><g:link class="list" controller="measurement">List measurements</g:link></li>
            <li><g:link class="create" controller="measurement" action="create">Create new measurement</g:link></li>
            <li><g:link class="import" controller="measurement" action="importData">Import</g:link></li>
        </content>
        <h1>Before we can start importing measurements, we need features</h1>

        <p>At this moment the measurement importer can not be used. The reason for this is that no features are known at this moment. Please import the features you want using the <g:link class="import" controller="feature" action="importData">feature importer</g:link> or <g:link class="create" controller="feature" action="create">create the features by hand</g:link>. As soon as features are present the measurement importer will become usable.</p>
    </body>
</html>
