<%@ page import="org.dbxp.sam.FeaturesAndGroups" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'featuresAndGroups.label', default: 'FeaturesAndGroups')}"/>
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
    <g:hasErrors bean="${featuresAndGroupsInstance}">
        <div class="errors">
            <g:renderErrors bean="${featuresAndGroupsInstance}" as="list"/>
        </div>
    </g:hasErrors>
    <g:form action="save">
        <div class="dialog">
            <table>
                <tbody>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="feature"><g:message code="featuresAndGroups.feature.label"
                                                        default="Feature"/></label>
                    </td>
                    <td valign="top"
                        class="value ${hasErrors(bean: featuresAndGroupsInstance, field: 'feature', 'errors')}">
                        <g:select name="feature.id" from="${org.dbxp.sam.Feature.list()}" optionKey="id"
                                  value="${featuresAndGroupsInstance?.feature?.id}"/>
                    </td>
                </tr>

                <tr class="prop">
                    <td valign="top" class="name">
                        <label for="featureGroup"><g:message code="featuresAndGroups.featureGroup.label"
                                                             default="Feature Group"/></label>
                    </td>
                    <td valign="top"
                        class="value ${hasErrors(bean: featuresAndGroupsInstance, field: 'featureGroup', 'errors')}">
                        <g:select name="featureGroup.id" from="${org.dbxp.sam.FeatureGroup.list()}" optionKey="id"
                                  value="${featuresAndGroupsInstance?.featureGroup?.id}"/>
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
