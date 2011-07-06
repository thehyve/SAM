
<%@ page import="org.dbxp.moduleBase.Study" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'study.label', default: 'Study')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'study.id.label', default: 'Id')}" />
                        
                            <g:sortableColumn property="studyToken" title="${message(code: 'study.studyToken.label', default: 'Study Token')}" />
                        
                            <g:sortableColumn property="isDirty" title="${message(code: 'study.isDirty.label', default: 'Is Dirty')}" />
                        
                            <g:sortableColumn property="gscfVersion" title="${message(code: 'study.gscfVersion.label', default: 'Gscf Version')}" />
                        
                            <g:sortableColumn property="name" title="${message(code: 'study.name.label', default: 'Name')}" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${studyInstanceList}" status="i" var="studyInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${studyInstance.id}">${fieldValue(bean: studyInstance, field: "id")}</g:link></td>
                        
                            <td>${fieldValue(bean: studyInstance, field: "studyToken")}</td>
                        
                            <td><g:formatBoolean boolean="${studyInstance.isDirty}" /></td>
                        
                            <td>${fieldValue(bean: studyInstance, field: "gscfVersion")}</td>
                        
                            <td>${fieldValue(bean: studyInstance, field: "name")}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${studyInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
