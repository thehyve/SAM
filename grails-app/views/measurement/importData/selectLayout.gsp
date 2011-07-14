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
            <h1>Select layout</h1>
            <p>
                The file <span style="color: red;">${input.oringinalFilename}</span> has been succesfully read in.
                <%--This is a sample of it's contents:
                <%
                    def content_sample = "<table>"
                    for(int i = 0; i < session.text.size(); i++){
                        if(i == 5){
                            break;
                        }
                        if(session.text[i].size()==0){
                            content_sample += "<tr></tr>"
                        } else {
                            content_sample += "<tr>"
                            for(int j = 0; j < session.text[i].size(); j++){
                                if(j == 5){
                                    break;
                                }
                                content_sample += "<td style='border: 1px lightgray;'>"+session.text[i][j]+"</td>"
                            }
                            content_sample += "</tr>"
                        }
                    }
                    content_sample += "</table>"
                    println content_sample
                %>
            </p>
            <p> --%>
                Now we need to know which layout the file uses. There are two layouts you can choose from:
            </p>
            <form method="post">
                <div class='layoutchoice'>
                    <div>
                        <input type="radio" name="layoutselector" value="sample_layout" onclick="$('#subjectsample').slideUp('medium'); $('#samplesample').slideDown('medium');" <g:if test="${session.layoutguess=='sample_layout'}">checked=''</g:if>/>
                        <b> The sample layout
                            <g:if test="${session.layoutguess=='sample_layout'}">(<i>Our guess is that this file uses the sample layout</i>)</g:if>
                        </b>
                    </div>
                    <div id="samplesample" <g:if test="${session.layoutguess!='sample_layout'}">style="display: none"</g:if>>
                        Using the sample layout and the sample of the file contents, the data types would be as follows:
                        <%
                            def content_sample_sample_layout = "<table>"
                            for(int i = 0; i < session.text.size(); i++){
                                if(i == 5){
                                    break;
                                }
                                if(session.text[i].size()==0){
                                    content_sample_sample_layout += "<tr></tr>"
                                } else {
                                    content_sample_sample_layout += "<tr>"
                                    for(int j = 0; j < session.text[i].size(); j++){
                                        if(j == 5){
                                            break;
                                        }
                                        if(i==0){
                                            if(j==0 && session.text[i][j]!=null && session.text[i][j].length()!=0){
                                                content_sample_sample_layout += '<td style="border: 1px solid lightgray;"><span class="badcell" style="color: black;"> This cell contains data ("'+session.text[i][j]+'"), this will be ignored.</span></td>'
                                            } else {
                                                def colour = ""
                                                if(j==1){colour = "darkgreen"}
                                                if(j==2){colour = "lightseagreen"}
                                                if(j==3){colour = "green"}
                                                content_sample_sample_layout += '<td style="border: 1px solid lightgray;"><span style="color: '+colour+';">'+session.text[i][j]+"</td><span>"
                                            }
                                        } else {
                                            def colour = ""
                                            if(j==0){colour = "purple"}
                                            else{colour = "blue"}
                                            content_sample_sample_layout += '<td style="border: 1px solid lightgray;"><span style="color: '+colour+';">'+session.text[i][j]+"</td><span>"
                                        }
                                    }
                                    content_sample_sample_layout += "</tr>"
                                }
                            }
                            content_sample_sample_layout += "</table>"
                            println content_sample_sample_layout
                        %>
                    </div>
                </div>
                <div class='layoutchoice'>
                    <div>
                        <input type="radio" name="layoutselector" value="subject_layout" onclick="$('#samplesample').slideUp('medium'); $('#subjectsample').slideDown('medium');" <g:if test="${session.layoutguess=='subject_layout'}">checked=''</g:if>/>
                        <b> The subject layout
                            <g:if test="${session.layoutguess=='subject_layout'}">(<i>Our guess is that this file uses the subject layout</i>)</g:if>
                        </b>
                    </div>
                    <div id="subjectsample" <g:if test="${session.layoutguess!='subject_layout'}">style="display: none"</g:if>>
                        Using the subject layout and the sample of the file contents, the data types would be as follows:
                        <%
                            def content_sample_subject_layout = "<table>"
                            for(int i = 0; i < session.text.size(); i++){
                                if(i == 5){
                                    break;
                                }
                                if(session.text[i].size()==0){
                                    content_sample_subject_layout += "<tr></tr>"
                                } else {
                                    content_sample_subject_layout += "<tr>"
                                    for(int j = 0; j < session.text[i].size(); j++){
                                        if(j == 5){
                                            break;
                                        }
                                        if(i==0){
                                            if(j==0 && session.text[i][j]!=null && session.text[i][j].length()!=0){
                                                content_sample_subject_layout += '<td style="border: 1px solid lightgray;"><span class="badcell" style="color: black;"> This cell contains data ("'+session.text[i][j]+'"), this will be ignored.</span></td>'                                        } else {
                                                content_sample_subject_layout += '<td style="border: 1px solid lightgray;"><span style="color: darkgreen;">'+session.text[i][j]+"</td><span>"
                                            }
                                        } else {
                                            if(i==1){
                                                if(j==0 && session.text[i][j]!=null && session.text[i][j].length()!=0){
                                                    content_sample_subject_layout += '<td style="border: 1px solid lightgray;"><span class="badcell" style="color: black;"> This cell contains data ("'+session.text[i][j]+'"), this will be ignored.</span></td>'
                                                } else {
                                                    content_sample_subject_layout += '<td style="border: 1px solid lightgray;"><span style="color: peru;">'+session.text[i][j]+"</td><span>"
                                                }
                                            } else {
                                                def colour = ""
                                                if(j==0){colour = "gray"}
                                                else{colour = "blue"}
                                                content_sample_subject_layout += '<td style="border: 1px solid lightgray;"><span style="color: '+colour+';">'+session.text[i][j]+"</td><span>"
                                            }
                                        }
                                    }
                                    content_sample_subject_layout += "</tr>"
                                }
                            }
                            content_sample_subject_layout += "</table>"
                            println content_sample_subject_layout
                        %>
                    </div>
                </div>
                <g:submitButton name="previous" value="Previous" action="previous"/>
                <g:submitButton name="next" value="Next" action="next"/>
            </form>
        </div>
    </body>
</html>