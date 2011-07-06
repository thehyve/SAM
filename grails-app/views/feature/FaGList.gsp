<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head></head>
    <body>
        <g:each in="${org.dbxp.sam.FeaturesAndGroups.findAllByFeature(featureInstance)}" var="f">
            <g:form method="post" action="removeGroup">
                <g:hiddenField name="fgid" value="${f?.id}"/>
                <li>
                    <g:link controller="featureGroup" action="show" id="${f?.featureGroup.id}">${f?.featureGroup.name.encodeAsHTML()}</g:link>
                    <span class="buttons">
                        <span class="button">
                            <g:actionSubmit class="delete" action="removeGroup" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/>
                        </span>
                    </span>
                </li>
            </g:form>
        </g:each>
    </body>
</html>