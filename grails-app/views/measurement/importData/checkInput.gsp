<%@ page import="org.dbxp.moduleBase.Study; org.dbxp.moduleBase.Assay" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Measurement importer</title>
        <r:script type="text/javascript" disposition="head">
            $(document).ready(function() {
                $("#dialog").dialog({
                    width: 'auto',
                    autoOpen: false,
                    modal: true
                });
            });

            function newInputForm(obj, key){
                var op = $('input[name="operatorHidden'+key+'"]').val();
                var val = $('input[name="valueHidden'+key+'"]').val();
                var co = $('input[name="commentHidden'+key+'"]').val();
                $("#dialog").html("<div id='inputFields"+key+"'><p>Enter the measurement value (a number) here.<br><input name='valueInput"+key+"' type='text' style='width: 300px;' value='"+val+"'/></p><p>Enter the operator ('<' or '>') here.<br><input name='operatorInput"+key+"' type='text' value='"+op+"'/></p><p>Enter any comments here.<br><input name='commentInput"+key+"' type='text' style='width: 300px;' value='"+co+"'/></p><br><b><a href='#' onclick='newObjContent(["+key+"]); return false;'>Confirm these changes</a></b></div>");
                $("#dialog").dialog('open');
            }

            function newObjContent(key){
                busy = false;
                var objA = $('input[name="operatorInput'+key+'"]');
                var objB = $('input[name="valueInput'+key+'"]');
                var objC = $('input[name="commentInput'+key+'"]');
                var valA = jQuery.trim(objA.val());
                var valB = jQuery.trim(objB.val());
                var valC = jQuery.trim(objC.val());
                var obj = $('td[id="'+key+'"]');
                obj.removeClass("importerOperatorCell importerCommentCell")
                var content = ""+valA+""+valB+" "+valC
                if(content.length>25){
                    obj.html('<div class="tooltip importerInteractiveCell">'+content.substring(0,19)+' &hellip;<span>'+content+'</span></div>');
                } else {
                    obj.html(content);
                }
                if(valC!=null && valC!=""){
                    obj.addClass("importerCommentCell")
                } else {
                    if(valA!=null && valA!=""){
                        obj.addClass("importerOperatorCell")
                    }
                }
                $('input[name="operatorHidden'+key+'"]').val(valA);
                $('input[name="valueHidden'+key+'"]').val(valB);
                $('input[name="commentHidden'+key+'"]').val(valC);
                $("#dialog").html("");
                $("#dialog").dialog('close');
            }
        </r:script>
    </head>
    <body>
        <content tag="contextmenu">
            <li><g:link class="list" controller="measurement">List measurements</g:link></li>
            <li><g:link class="create" controller="measurement" action="create">Create new measurement</g:link></li>
            <li><g:link class="import" controller="measurement" action="importData">Import</g:link></li>
        </content>
        <div class="data">
            <h1>Confirm input</h1>
            <p>
                Please check your input. Use the 'Previous' button to make changes when necessary. A cell with a white background contains only a number. <span class="importerOperatorCell">A cell with this color background</span> contains an operator, and <span class="importerCommentCell">a cell with this color background</span> contains at least a comment. To change the contents of special cells, such as those containing features, please go to the previous page. Clicking on a regular cell allows you to edit it's contents.
            </p>
            <form method="post">
                <%
                    def discard_i = []
                    def discard_j = []
                %>
                <table style="width: auto;">
                    <g:each in="${edited_text}" var="row" status="i">
                        <tr>
                            <g:each in="${row}" var="column" status="j">
                                <g:if test="${!(i==0&j==0)}">
                                    <%
                                        def op = operator.get(i+','+j)
                                        def co = comments.get(i+','+j)
                                    %>
                                    <g:if test="${i==0 || j==0}">
                                        <g:if test="${column==null}">
                                            <td style="border: 1px solid lightgray;">Discarded</td>
                                            <%
                                                if(i==0){
                                                    discard_j.add(j)
                                                }
                                                if(j==0){
                                                    discard_i.add(i)
                                                }
                                            %>
                                        </g:if>
                                        <g:else>
                                            <td style="border: 1px solid lightgray;">
                                                <g:if test="${column.class!=java.lang.String}">
                                                    <g:if test="${column.class==org.dbxp.sam.Feature}">
                                                        <div class="tooltip">
                                                            ${column.name}
                                                            <span>
                                                                <g:include controller="feature" action="minimalShow" params="['featureInstance': column]"/>
                                                            </span>
                                                        </div>
                                                    </g:if>
                                                    <g:else>
                                                        ${column.name}
                                                    </g:else>
                                                </g:if>
                                                <g:else>
                                                    ${column}
                                                </g:else>
                                            </td>
                                        </g:else>
                                    </g:if>
                                    <g:else>
                                        <g:hiddenField name="operatorHidden${i},${j}" value="${op}"/>
                                        <g:hiddenField name="commentHidden${i},${j}" value="${co}"/>
                                        <g:hiddenField name="valueHidden${i},${j}" value="${column}"/>
                                        <td id="${i},${j}" onclick="newInputForm($(this), '${i},${j}');" style="border: 1px solid lightgray;"
                                        <g:if test="${op!=null && co==null}">
                                            class="importerInteractiveCell importerOperatorCell"
                                        </g:if>
                                        <g:if test="${co!=null}">
                                            class="importerInteractiveCell importerCommentCell"
                                        </g:if>
                                        >
                                        <%
                                            def content = ""
                                            if(op!=null){
                                                content += op
                                            }
                                            if(column!=null){
                                                content += column
                                            }
                                            if(co!=null){
                                                content += " "+co
                                            }
                                            content = content.trim()
                                        %>
                                        <g:if test="${discard_i.contains(i) || discard_j.contains(j)}">
                                        &nbsp;<del>
                                            <g:if test="${content.length()>25}">
                                                ${content.substring(0,19)} &hellip;
                                            </g:if>
                                            <g:else>
                                                ${content}
                                            </g:else>
                                        </g:if>
                                        <g:else>
                                            <g:if test="${content.length()>25}">
                                                <div class="tooltip">
                                                    ${content.substring(0,19)} &hellip;
                                                    <span>
                                                        ${content}
                                                    </span>
                                                </div>
                                            </g:if>
                                            <g:else>
                                                ${content}
                                            </g:else>
                                        </g:else>
                                        <g:if test="${discard_i.contains(i) || discard_j.contains(j)}">
                                        &nbsp;</del>
                                        </g:if>
                                        </td>
                                    </g:else>
                                </g:if>
                                <g:else>
                                    <td></td>
                                </g:else>
                            </g:each>
                        </tr>
                    </g:each>
                </table>
                <g:submitButton name="previous" value="Previous" action="previous"/>
                <g:submitButton name="save" value="Save your data" action="save"/>
            </form>
        </div>
        <div id="dialog" title="Edit cell contents">
        </div>
    </body>
</html>