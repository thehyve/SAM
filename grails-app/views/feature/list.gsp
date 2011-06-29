<%@ page import="org.dbnp.gdt.Template; org.dbxp.sam.Feature" %>
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
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <div class="list">
        <table>
            <thead>
            <tr>

                <g:sortableColumn property="id" title="${message(code: 'feature.id.label', default: 'Id')}"/>

                <g:sortableColumn property="name" title="${message(code: 'feature.name.label', default: 'Name')}"/>

                <g:sortableColumn property="unit" title="${message(code: 'feature.unit.label', default: 'Unit')}"/>

            </tr>
            </thead>
            <tbody>
            <g:each in="${featureInstanceList}" status="i" var="featureInstance">
                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">

                    <td><g:link action="show"
                                id="${featureInstance.id}">${fieldValue(bean: featureInstance, field: "id")}</g:link></td>

                    <td>${fieldValue(bean: featureInstance, field: "name")}</td>

                    <td>${fieldValue(bean: featureInstance, field: "unit")}</td>

                </tr>
            </g:each>
            </tbody>
        </table>
    </div>

    <div class="paginateButtons">
        <g:paginate total="${featureInstanceTotal}"/>
    </div>

    <dif id="list">
        <hr>
        <%

            def derp = Feature.giveDomainFields()
            println "Feature mandatory template fields: " + derp
        %>
        <hr>
        <%
            def derp2 = Template.list()
            if(derp2.size()==0){
                def template = new Template(['name':'test','description':'Template for testing purposes']);
                    if (template.validate() && template.save(flush: true)) {
                        println "Template succesfully saved, check again";
                    } else {
                        println 'Template could not be created because errors occurred.';
                    }
            }
            println "Feature templates: " + derp2
        %>
        <hr>
    </dif>
</div>
</body>
</html>
