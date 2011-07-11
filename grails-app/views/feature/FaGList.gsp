<table id="featureGroups_list">
    <g:each in="${org.dbxp.sam.FeaturesAndGroups.findAllByFeature(featureInstance)}" var="f" status="i">

            <tr class="prop ${(i % 2) == 0 ? 'odd' : 'even'}">

                <td>
                    <g:link controller="featureGroup" action="show" id="${f?.featureGroup.id}">${f?.featureGroup.name.encodeAsHTML()}</g:link>
                </td>
                <td>
                    <g:form method="post" action="removeGroup">
                        <g:hiddenField name="fagid" value="${f?.id}"/>
                        <span class="buttons button">
                            <g:actionSubmit class="delete" action="removeGroup" value="Remove from feature group" onclick="return confirm('Are you sure?');"/>
                        </span>
                    </g:form>
                </td>
            </tr>
    </g:each>
</table>