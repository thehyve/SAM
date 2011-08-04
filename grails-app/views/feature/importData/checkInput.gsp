<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Feature importer</title>
        <r:require modules="tableEditor"/>
        <style type="text/css">
            .helpContent {
                display: none;
            }
            div .tableEditor .column .helpIcon {
                display: none;
            }
        </style>
    </head>
    <body>
        <content tag="contextmenu">
            <li><g:link class="list" controller="feature">List features</g:link></li>
            <li><g:link class="create" controller="feature" action="create">Create new feature</g:link></li>
            <li><g:link class="import" controller="feature" action="importData">Import</g:link></li>
            <li><g:link class="list" controller="featureGroup">List feature groups</g:link></li>
        </content>
        <div class="data">
            <h1>Confirm input</h1>
            <p>
                Please check your input. Use the 'Previous' button to make changes when necessary.
            </p>
            <g:if test="${message}">
                <div class="errors">${message}</div><br />
            </g:if>
            <form method="post" novalidate>
                <div class="wizard" id="wizard">
                    <div class="tableEditor">
                        <g:set var="showHeader" value="${true}"/>
                        <g:each status="index" var="entity" in="${featureList}">
                            <g:if test="${showHeader}">
                                <g:set var="showHeader" value="${false}"/>
                                <div class="header">
                                    <div class="firstColumn"></div>
                                    <af:templateColumnHeaders entity="${entity}" class="column" />
                                </div>
                                <input type="hidden" name="entity" value="${entity.class.name}">
                            </g:if>
                            <div class="row">
                                <div class="firstColumn"></div>
                                <af:templateColumns id="${entity.hashCode()}" entity="${entity}" template="${entity.template}" name="entity_${entity.identifier}" class="column" subject="${entity.hashCode()}" addDummy="true" />
                            </div>
                        </g:each>
                    </div>
                </div>

                <br />

                <g:submitButton name="previous" value="Previous" action="previous"/>
                <g:submitButton name="save" value="Save your data" action="save"/>
            </form>
        </div>
    </body>
</html>