<%@ page import="sam_2.Measurement" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'measurement.label', default: 'Measurement')}"/>
    <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>

<body>
<div class="nav">
    <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a>
    </span>
    <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label"
                                                                           args="[entityName]"/></g:link></span>
</div>

<div class="body">
    <h1><g:message code="default.create.label" args="[entityName]"/></h1>
    <g:if test="${flash.message}">
        <div class="message">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${measurementInstance}">
        <div class="errors">
            <g:renderErrors bean="${measurementInstance}" as="list"/>
        </div>
    </g:hasErrors>
    <g:form action="save">
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="value"><g:message code="measurement.value.label" default="Value"/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: measurementInstance, field: 'value', 'errors')}">
                        <g:textField name="value" value="${fieldValue(bean: measurementInstance, field: 'value')}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="operator"><g:message code="measurement.operator.label" default="Operator"/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: measurementInstance, field: 'operator', 'errors')}">
                        <g:textField name="operator" value="${measurementInstance?.operator}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="comments"><g:message code="measurement.comments.label" default="Comments"/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: measurementInstance, field: 'comments', 'errors')}">
                        <g:textField name="comments" value="${measurementInstance?.comments}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="sample"><g:message code="measurement.sample.label" default="Sample"/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: measurementInstance, field: 'sample', 'errors')}">
                        <g:select name="sample.id" from="${org.dbxp.moduleBase.Sample.list()}" optionKey="id"
                                  value="${measurementInstance?.sample?.id}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="feature"><g:message code="measurement.feature.label" default="Feature"/></label>
                    </td>
                    <td valign="top" class="value ${hasErrors(bean: measurementInstance, field: 'feature', 'errors')}">
                        <g:select name="feature.id" from="${sam_2.Feature.list()}" optionKey="id"
                                  value="${measurementInstance?.feature?.id}"/>
                    </td>
                </tr>

                </tbody>
            </table>
        </div>

        <div class="buttons">
            <span class="button"><g:submitButton name="create" class="save"
                                                 value="${message(code: 'default.button.create.label', default: 'Create')}"/></span>
        </div>
    </g:form>
</div>
</body>
</html>
