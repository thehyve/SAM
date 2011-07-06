<%@ page import="org.dbxp.sam.FeaturesAndGroups; org.dbnp.gdt.Template; org.dbxp.sam.Feature" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main"/>
        <g:set var="entityName" value="${message(code: 'feature.label', default: 'Feature')}"/>
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

                        <g:sortableColumn property="name" title="${message(code: 'feature.name.label', default: 'Name')}"/>

                        <g:sortableColumn property="unit" title="${message(code: 'feature.unit.label', default: 'Unit')}"/>

                        <td><g:link action="list" controller="featureGroup">Groups</g:link></td>

                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${featureInstanceList}" status="i" var="featureInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                            <td><g:link action="show"
                                        id="${featureInstance.id}">${fieldValue(bean: featureInstance, field: "name")}</g:link></td>

                            <td>${fieldValue(bean: featureInstance, field: "unit")}</td>
                            
                            <td>
                                <g:each in="${FeaturesAndGroups.findAllByFeature(featureInstance)}" var="g">
                                    <li><g:link action="show" controller="featuresAndGroups"
                                        id="${g.id}">${fieldValue(bean: g.featureGroup, field: "name")}</g:link>
                                    </li>
                                </g:each>
                            </td>
                            
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>

            <div class="paginateButtons">
                <g:paginate total="${featureInstanceTotal}"/>
            </div>
        </div>
    </body>
</html>
