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
            <h1>Choose columns</h1>
            <p>
                You have chosen the <g:if test="${session.layout=='sample_layout'}">sample layout</g:if><g:if test="${session.layout=='subject_layout'}">subject layout</g:if>. On this page, we have tried to match your data with our data. You must double check these matches, and confirm your final choice.
            </p>
            <table>
                <%
                    for(int i = 0; i < session.text.size(); i++){
                        if(session.text[i].size()==0){
                            println "<tr></tr>"
                        } else {
                %>
                            <tr>
                <%
                            for(int j = 0; j < session.text[i].size(); j++){
                                if(!(i==0&j==0)){

                %>
                                    <td style='border: 1px lightgray;'>${session.text[i][j]}
                <%
                                    if(i==0 && j>0){
                %>
                                        <g:select from="${session.features}" value="${session.feature_matches.get(session.text[i][j])}"/>
                                        </td>
                <%
                                    }
                                    if(j==0){
                %>
                                    <g:select from="${session.samples}" value="${session.sample_matches.get(session.text[i][j])}"/>
                <%
                                    }
                                    if(i>1){
                %>
                                        </td>
                <%
                                    }
                %>
                <%
                                } else {
                %>
                                    <td></td>
                <%
                                }
                            }
                %>
                            </tr>
                <%
                        }
                    }
                %>
            </table>
            <form method="post">
                <g:submitButton name="previous" value="Previous" action="previous"/>
                <g:submitButton name="next" value="Next" action="next"/>
            </form>
        </div>
    </body>
</html>