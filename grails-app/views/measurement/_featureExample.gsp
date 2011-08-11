<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    </head>
    <body>
        <table class="">
            <tbody>
                <% def ii = 0%>
                <g:each in="${featureInstance.giveFields()}" var="field" status="i">
                    <tr class="prop ${(i % 2) == 0 ? 'odd' : 'even'}">
                        <td valign="top">
                            ${field.name.capitalize()}
                        </td>
                        <td valign="top" >
                            ${featureInstance.getFieldValue(field.toString())}
                        </td>
                        <% ii = i + 1%>
                    </tr>
                </g:each>

                <tr class="prop  ${(ii % 2) == 0 ? 'odd' : 'even'}">
                    <td valign="top" class="name">Feature Groups</td>

                    <td valign="top" style="text-align: left;" class="value">
                        <g:each in="${org.dbxp.sam.FeaturesAndGroups.findAllByFeature(featureInstance)}" var="f" status="i">
                            <g:link controller="featureGroup" action="show" id="${f?.featureGroup.id}">${f?.featureGroup.name.encodeAsHTML()}</g:link><br />
                        </g:each>
                    </td>

                </tr>
            </tbody>
        </table>
    </body>
</html>