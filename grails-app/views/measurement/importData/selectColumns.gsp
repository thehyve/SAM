<%@ page import="org.dbxp.moduleBase.Study; org.dbxp.moduleBase.Assay" %>
<html>
    <head>
      <meta name="layout" content="main"/>
      <title>Measurement importer</title>
    </head>
    <body>
        <content tag="contextmenu">
            <li><g:link class="list" controller="measurement">List measurements</g:link></li>
            <li><g:link class="create" controller="measurement" action="create">Create new measurement</g:link></li>
            <li><g:link class="import" controller="measurement" action="importData">Import</g:link></li>
        </content>
        <div class="data">
            <h1>Confirm matches</h1>
            <p>
                You have chosen the <g:if test="${layout=='sample_layout'}">sample layout</g:if><g:if test="${layout=='subject_layout'}">subject layout</g:if>. On this page, we have tried to match your data with our data. You must double check these matches, and confirm your final choice.
            </p>
            <form method="post">
                <g:if test="${layout=='sample_layout'}">
                    <table>
                        <g:each in="${text}" var="row" status="i">
                            <g:if test="${row.size()==0}">
                                <tr></tr>
                            </g:if>
                            <g:else>
                                <tr>
                                    <g:each in="${row}" var="column" status="j">
                                        <g:if test="${!(i==0&j==0)}">
                                            <td style="border: 1px solid lightgray;">${column}
                                                <g:if test="${i==0&&j>0}">
                                                    <g:if test="${edited_text!=null && edited_text[i][j]!=column}">
                                                        <g:select name="${i},${j}" from="${features}" value="${edited_text[i][j]}"/>
                                                    </g:if>
                                                    <g:else>
                                                        <g:select name="${i},${j}" from="${features}" value="${feature_matches.get(column)}"/>
                                                    </g:else>
                                                </g:if>
                                                <g:if test="${j==0}">
                                                    <g:if test="${edited_text!=null && edited_text[i][j]!=column}">
                                                        <g:select name="${i},${j}" from="${samples}" value="${edited_text[i][j]}"/>
                                                    </g:if>
                                                    <g:else>
                                                        <g:select name="${i},${j}" from="${samples}" value="${sample_matches.get(column)}"/>
                                                    </g:else>
                                                </g:if>
                                            </td>
                                        </g:if>
                                        <g:else>
                                            <td></td>
                                        </g:else>
                                    </g:each>
                                </tr>
                            </g:else>
                        </g:each>
                    </table>
                </g:if>
                <g:submitButton name="previous" value="Previous" action="previous"/>
                <g:submitButton name="next" value="Next" action="next"/>
            </form>
        </div>
    </body>
</html>