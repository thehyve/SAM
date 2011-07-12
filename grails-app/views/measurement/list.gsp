<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <g:set var="entityName" value="${message(code: 'measurement.label', default: 'Measurement')}"/>
        <title><g:message code="default.list.label" args="[entityName]"/></title>
    </head>

    <body>
        <content tag="contextmenu">
            <li><g:link class="list" controller="measurement">List measurements</g:link></li>
            <li><g:link class="create" controller="measurement" action="create">Create new measurement</g:link></li>
            <li><g:link class="import" controller="measurement" action="importData">Import</g:link></li>
        </content>
        <h1><g:message code="default.list.label" args="[entityName]"/></h1>

        <div class="data">
            <div class="list">
                <g:form method="post" name="deleteForm" action="delete">
                    <g:hiddenField name="id" value=""/>
                    <table class="datatables paginate sortable filter">
                        <thead>
                        <tr>
                            <th>Id</th>
                            <th>Value</th>
                            <th>Operator</th>
                            <th>Comments</th>

                            <th><g:message code="measurement.sample.label" default="Sample"/></th>

                            <th><g:message code="measurement.feature.label" default="Feature"/></th>

                            <th class="nonsortable"></th>

                        </tr>
                        </thead>
                        <tbody>
                        <g:each in="${measurementInstanceList}" status="i" var="measurementInstance">
                            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                                <td><g:link action="show"
                                            id="${measurementInstance.id}">${fieldValue(bean: measurementInstance, field: "id")}</g:link></td>

                                <td>${fieldValue(bean: measurementInstance, field: "value")}</td>

                                <td>${fieldValue(bean: measurementInstance, field: "operator")}</td>

                                <td>${fieldValue(bean: measurementInstance, field: "comments")}</td>

                                <td>${fieldValue(bean: measurementInstance, field: "sample")}</td>

                                <td>${fieldValue(bean: measurementInstance, field: "feature")}</td>

                                <td><g:buttonsViewEditDelete controller="measurement" id="${measurementInstance.id}"/></td>

                            </tr>
                        </g:each>
                        </tbody>
                    </table>
                </g:form>
            </div>

        </div>

    </body>
</html>
