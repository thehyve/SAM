<g:if test="${featureInstance.template!=null}">
    <table>
        <g:each in="${featureInstance.giveTemplateFields()}" var="field" status="i">
            <tr class="prop ${(i % 2) == 0 ? 'odd' : 'even'}">
                <td valign="top">
                    ${field.name.capitalize()}
                    <g:if test="${field.required}">
                        <i>(required)</i>
                    </g:if>
                </td>
                <td valign="top" class="value ${hasErrors(bean: featureInstance, field: field.escapedName(), 'errors')}">
                    <g:textField name="${field.escapedName()}" value="${featureInstance.getFieldValue(field.toString())}"/>
                </td>
            </tr>
        </g:each>
    </table>
</g:if>