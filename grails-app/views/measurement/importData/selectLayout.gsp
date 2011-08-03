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
                The file <b>${input.originalFilename}</b> has been successfully read in.
                Now we need to know which layout the file uses. There are two layouts you can choose from:
            </p>
            <form method="post">
                <div class='layoutchoice'>
                    <div style="vertical-align: middle; text-align:center;">
                        <input type="radio" name="layoutselector" value="sample_layout" onclick="$('#subjectsample').slideUp('medium'); $('#samplesample').slideDown('medium');" <g:if test="${layoutguess=='sample_layout'}">checked=''</g:if>/>
                        <b>The sample layout</b>
                    </div>
                    <div id="samplesample" <g:if test="${layoutguess!='sample_layout'}">style="display: none"</g:if>>
                        <g:if test="${layoutguess=='sample_layout'}">Our guess is that this file uses the sample layout. </g:if>Using the sample layout and the sample of the file contents, the data types would be as follows:
                        <%
                            def content_sample_sample_layout = "<table style='width: auto;'>"
                            for(int i = 0; i < text.size(); i++){
                                if(i == 5){
                                    break;
                                }
                                if(text[i].size()==0){
                                    content_sample_sample_layout += "<tr></tr>"
                                } else {
                                    content_sample_sample_layout += "<tr>"
                                    for(int j = 0; j < text[i].size(); j++){
                                        if(j == 5){
                                            break;
                                        }
                                        if(i==0){
                                            if(j==0 && text[i][j]!=null && text[i][j].length()!=0){
                                                def tmp = 'Warning: This cell contains data ("'+text[i][j]+'"), this will be ignored.';
                                                if(tmp.length()>25){
                                                    content_sample_sample_layout += '<td style="border: 1px solid lightgray; color: black;" class="badcell"><div class="tooltip importerInteractiveCell">'+tmp.substring(0,19)+' &hellip;<span>'+tmp+'</span></div></td>';
                                                } else {
                                                    content_sample_sample_layout += '<td style="border: 1px solid lightgray; color: black;" class="badcell">'+tmp+'</td>'
                                                }
                                            } else {
                                                def colour = ""
                                                if(j==1){colour = "darkgreen"}
                                                if(j==2){colour = "lightseagreen"}
                                                if(j==3){colour = "green"}
                                                content_sample_sample_layout += '<td style="border: 1px solid lightgray;color: '+colour+';">'
                                                if(text[i][j]!=null && text[i][j].length()>25){
                                                    content_sample_sample_layout += text[i][j].substring(0,19)+"&hellip;"
                                                } else {
                                                    content_sample_sample_layout += text[i][j]
                                                }
                                                content_sample_sample_layout += "</td>"
                                            }
                                        } else {
                                            def colour = ""
                                            if(j==0){colour = "purple"}
                                            else{colour = "blue"}
                                            content_sample_sample_layout += '<td style="border: 1px solid lightgray; color: '+colour+';">'
                                            if(text[i][j]!=null && text[i][j].length()>25){
                                                content_sample_sample_layout += text[i][j].substring(0,19)+"&hellip;"
                                            } else {
                                                content_sample_sample_layout += text[i][j]
                                            }
                                            content_sample_sample_layout += "</td>"
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
                    <g:if test="${disableSubjectLayout}">
                        Because the selected assay does not contain enough information to be able to use the subject layout (such as event timepoints and subject names), the subject layout cannot be used. If you do want to upload a file that uses the subject layout, please enter the required information into GSCF and try again.
                    </g:if>
                    <g:else>
                        <div style="vertical-align: middle; text-align:center;">
                            <input type="radio" name="layoutselector" value="subject_layout" onclick="$('#samplesample').slideUp('medium'); $('#subjectsample').slideDown('medium');" <g:if test="${layoutguess=='subject_layout'}">checked=''</g:if>/>
                            <b>The subject layout</b>
                        </div>
                        <div id="subjectsample" <g:if test="${layoutguess!='subject_layout'}">style="display: none"</g:if>>
                            <g:if test="${layoutguess=='subject_layout'}">Our guess is that this file uses the subject layout. </g:if>
                            Using the subject layout and the sample of the file contents, the data types would be as follows:
                            <%
                                def content_sample_subject_layout = "<table style='width: auto;'>"
                                for(int i = 0; i < text.size(); i++){
                                    if(i == 5){
                                        break;
                                    }
                                    if(text[i].size()==0){
                                        content_sample_subject_layout += "<tr></tr>"
                                    } else {
                                        content_sample_subject_layout += "<tr>"
                                        for(int j = 0; j < text[i].size(); j++){
                                            if(j == 5){
                                                break;
                                            }
                                            if(i==0){
                                                if(j==0 && text[i][j]!=null && text[i][j].length()!=0){
                                                    def tmp = 'Warning: This cell contains data ("'+text[i][j]+'"), this will be ignored.';
                                                    if(tmp.length()>25){
                                                        content_sample_subject_layout += '<td style="border: 1px solid lightgray; color: black;" class="badcell"><div class="tooltip importerInteractiveCell">'+tmp.substring(0,19)+' &hellip;<span>'+tmp+'</span></div></td>';
                                                    } else {
                                                        content_sample_subject_layout += '<td style="border: 1px solid lightgray; color: black;" class="badcell">'+tmp+'</td>'
                                                    }
                                                } else {
                                                    content_sample_subject_layout += '<td style="border: 1px solid lightgray; color: darkgreen;">';
                                                    if(text[i][j]!=null && text[i][j].length()>25){
                                                        content_sample_subject_layout += text[i][j].substring(0,19)+"&hellip;"
                                                    } else {
                                                        content_sample_subject_layout += text[i][j]
                                                    }
                                                    content_sample_subject_layout += "</td>"
                                                }
                                            } else {
                                                if(i==1){
                                                    if(j==0 && text[i][j]!=null && text[i][j].length()!=0){
                                                        def tmp = 'Warning: This cell contains data ("'+text[i][j]+'"), this will be ignored.';
                                                        if(tmp.length()>25){
                                                            content_sample_subject_layout += '<td style="border: 1px solid lightgray; color: black;" class="badcell"><div class="tooltip importerInteractiveCell">'+tmp.substring(0,19)+' &hellip;<span>'+tmp+'</span></div></td>';
                                                        } else {
                                                            content_sample_subject_layout += '<td style="border: 1px solid lightgray; color: black;" class="badcell">'+tmp+'</td>'
                                                        }
                                                    } else {
                                                        content_sample_subject_layout += '<td style="border: 1px solid lightgray; color: peru;">';
                                                    if(text[i][j]!=null && text[i][j].length()>25){
                                                        content_sample_subject_layout += text[i][j].substring(0,19)+"&hellip;"
                                                    } else {
                                                        content_sample_subject_layout += text[i][j]
                                                    }
                                                    content_sample_subject_layout += "</td>"
                                                    }
                                                } else {
                                                    def colour = ""
                                                    if(j==0){colour = "gray"}
                                                    else{colour = "blue"}
                                                    content_sample_subject_layout += '<td style="border: 1px solid lightgray;  color: '+colour+';">';
                                                    if(text[i][j]!=null && text[i][j].length()>25){
                                                        content_sample_subject_layout += text[i][j].substring(0,19)+"&hellip;"
                                                    } else {
                                                        content_sample_subject_layout += text[i][j]
                                                    }
                                                    content_sample_subject_layout += "</td>"
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
                    </g:else>
                </div>
                <g:submitButton name="previous" value="Choose a different file" action="previous"/>
                <g:submitButton name="next" value="Next" action="next"/>
            </form>
        </div>
    </body>
</html>