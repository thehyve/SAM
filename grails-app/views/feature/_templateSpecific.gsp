<g:if test="${template!=null}">
    <table>
        <g:each in="${template.fields}" var="field" status="i">
            <tr class="prop ${(i % 2) == 0 ? 'odd' : 'even'}">
                <td valign="top" class="fieldName">
                    ${field.name.capitalize()}
                    <g:if test="${field.required}">
                        <i>(required)</i>
                    </g:if>
                </td>
                <td valign="top" class="value ${hasErrors(bean: featureInstance, field: field.escapedName(), 'errors')}">
                    <g:textField name="${field.escapedName()}" value="${values[ field.name ]}"/>
                </td>
            </tr>
        </g:each>
    </table>
</g:if>