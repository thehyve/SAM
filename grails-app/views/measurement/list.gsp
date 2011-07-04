<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'measurement.label', default: 'Measurement')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a>
    </span>
    <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label"
                                                                               args="[entityName]"/></g:link></span>
</div>

<div class="body">
    <h1><g:message code="default.list.label" args="[entityName]"/></h1>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="id" title="${message(code: 'measurement.id.label', default: 'Id')}"/>

                <g:sortableColumn property="value"
                                  title="${message(code: 'measurement.value.label', default: 'Value')}"/>

                <g:sortableColumn property="operator"
                                  title="${message(code: 'measurement.operator.label', default: 'Operator')}"/>

                <g:sortableColumn property="comments"
                                  title="${message(code: 'measurement.comments.label', default: 'Comments')}"/>

                <th><g:message code="measurement.sample.label" default="Sample"/></th>

                <th><g:message code="measurement.feature.label" default="Feature"/></th>

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

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>

    <div class="paginateButtons">
        <g:paginate total="${measurementInstanceTotal}"/>
    </div>
</div>
</body>
</html>
