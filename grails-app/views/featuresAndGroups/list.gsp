<%@ page import="org.dbxp.sam.FeaturesAndGroups" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'featuresAndGroups.label', default: 'FeaturesAndGroups')}"/>
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
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="id" title="${message(code: 'featuresAndGroups.id.label', default: 'Id')}"/>

                <th><g:message code="featuresAndGroups.feature.label" default="Feature"/></th>

                <th><g:message code="featuresAndGroups.featureGroup.label" default="Feature Group"/></th>

            </tr>
            </thead>
            <tbody>
            <g:each in="${featuresAndGroupsInstanceList}" status="i" var="featuresAndGroupsInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show"
                                id="${featuresAndGroupsInstance.id}">${fieldValue(bean: featuresAndGroupsInstance, field: "id")}</g:link></td>

                    <td>${fieldValue(bean: featuresAndGroupsInstance, field: "feature")}</td>

                    <td>${fieldValue(bean: featuresAndGroupsInstance, field: "featureGroup")}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>

    <div class="paginateButtons">
        <g:paginate total="${featuresAndGroupsInstanceTotal}"/>
    </div>
</div>
</body>
</html>
