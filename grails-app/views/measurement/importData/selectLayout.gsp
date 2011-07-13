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
                This is a sample of it's contents:
                <%
                    def content_sample = "<table>"
                    for(int i = 0; i < text.size(); i++){
                        if(i == 5){
                            break;
                        }
                        if(text[i].size()==0){
                            content_sample += "<tr></tr>"
                        } else {
                            content_sample += "<tr>"
                            for(int j = 0; j < text[i].size(); j++){
                                if(j == 5){
                                    break;
                                }
                                content_sample += "<td style='border: 1px solid lightgray;'>"+text[i][j]+"</td>"
                            }
                            content_sample += "</tr>"
                        }
                    }
                    content_sample += "</table>"
                    println content_sample
                %>
            </p>
            <p>
                Now we need to know which layout the file uses. There are two layouts you can choose from:
            </p>
            <ul>
                <li> The sample layout
                    <br>
                    Using the sample layout and the sample of the file contents, the data types would be as follows:
                    <%
                        def content_sample_sample_layout = "<table>"
                        for(int i = 0; i < text.size(); i++){
                            if(i == 3){
                                break;
                            }
                            if(text[i].size()==0){
                                content_sample_sample_layout += "<tr></tr>"
                            } else {
                                content_sample_sample_layout += "<tr>"
                                for(int j = 0; j < text[i].size(); j++){
                                    if(j == 3){
                                        break;
                                    }
                                    if(i==0){
                                        if(j==0 && text[i][j]!=null && text[i][j].length()!=0){
                                            content_sample_sample_layout += '<td style="border: 1px solid lightgray; padding: 18px 0px 18px 0px;"><span class="errors" style="color: black;"> This cell contains data ("'+text[i][j]+'"), but it should not.</span></td>'
                                        } else {
                                            def colour = ""
                                            if(j==1){colour = "darkgreen"}
                                            if(j==2){colour = "lightseagreen"}
                                            if(j==3){colour = "green"}
                                            content_sample_sample_layout += '<td style="border: 1px solid lightgray; padding: 18px 0px 18px 0px;"><span style="color: '+colour+';">'+text[i][j]+"</td><span>"
                                        }
                                    } else {
                                        def colour = ""
                                        if(j==0){colour = "purple"}
                                        else{colour = "blue"}
                                        content_sample_sample_layout += '<td style="border: 1px solid lightgray; padding: 18px 0px 18px 0px;"><span style="color: '+colour+';">'+text[i][j]+"</td><span>"
                                    }
                                }
                                content_sample_sample_layout += "</tr>"
                            }
                        }
                        content_sample_sample_layout += "</table>"
                        println content_sample_sample_layout
                    %>
                </li>
                <li> The subject layout
                    <br>
                    Using the subject layout and the sample of the file contents, the data types would be as follows:
                    <%
                        def content_sample_subject_layout = "<table>"
                        for(int i = 0; i < text.size(); i++){
                            if(i == 3){
                                break;
                            }
                            if(text[i].size()==0){
                                content_sample_subject_layout += "<tr></tr>"
                            } else {
                                content_sample_subject_layout += "<tr>"
                                for(int j = 0; j < text[i].size(); j++){
                                    if(j == 3){
                                        break;
                                    }
                                    if(i==0){
                                        if(j==0 && text[i][j]!=null && text[i][j].length()!=0){
                                            content_sample_subject_layout += '<td style="border: 1px solid lightgray; padding: 18px 0px 18px 0px;"><span class="errors" style="color: black;"> This cell contains data ("'+text[i][j]+'"), but it should not.</span></td>'
                                        } else {
                                            content_sample_subject_layout += '<td style="border: 1px solid lightgray; padding: 18px 0px 18px 0px;"><span style="color: darkgreen;">'+text[i][j]+"</td><span>"
                                        }
                                    } else {
                                        if(i==1){
                                            if(j==0 && text[i][j]!=null && text[i][j].length()!=0){
                                                content_sample_subject_layout += '<td style="border: 1px solid lightgray; padding: 18px 0px 18px 0px;"><span class="errors" style="color: black;"> This cell contains data ("'+text[i][j]+'"), but it should not.</span></td>'
                                            } else {
                                                content_sample_subject_layout += '<td style="border: 1px solid lightgray; padding: 18px 0px 18px 0px;"><span style="color: peru;">'+text[i][j]+"</td><span>"
                                            }
                                        } else {
                                            def colour = ""
                                            if(j==0){colour = "gray"}
                                            else{colour = "blue"}
                                            content_sample_subject_layout += '<td style="border: 1px solid lightgray; padding: 18px 0px 18px 0px;"><span style="color: '+colour+';">'+text[i][j]+"</td><span>"
                                        }
                                    }
                                }
                                content_sample_subject_layout += "</tr>"
                            }
                        }
                        content_sample_subject_layout += "</table>"
                        println content_sample_subject_layout
                    %>
                </li>
            </ul>
            <g:form method="post" name="importData" action="importData">
                <g:hiddenField name="assay" value=""/>
                <g:submitButton name="next" value="next">Next</g:submitButton>
            </g:form>
        </div>
    </body>
</html>
<html>