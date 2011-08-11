<%--
  Created by IntelliJ IDEA.
  User: Tjeerd
  Date: 2-8-11
  Time: 12:05
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Feature importer</title>
        <script type="text/javascript">
            function selectChange() {
                listSelects = $('select');
                var mapSelected = new Object();
                for(i=0; i<listSelects.length; i++) {
                    val = listSelects[ i ].value;
                    if(val!="") {
                        if(mapSelected[val]==null) {
                            mapSelected[val] = 1;
                        } else {
                            mapSelected[val]++;
                        }
                    }
                }

                blnDisabled = false;
                for(i=0; i<listSelects.length; i++) {
                    val = listSelects[ i ].value;
                    listSelects[ i ].style.color = '';
                    if(val!="") {
                        if(mapSelected[val]>1) {
                            listSelects[ i ].style.color = 'red';
                             blnDisabled = true;
                        } 
                    }
                }

                $("#_eventId_next").attr("Disabled", blnDisabled);
            }

        </script>
        
        <r:require module="importer" />
        
    </head>
    <body>
        <content tag="contextmenu">
      		<g:render template="contextmenu" />
        </content>
        <div class="data">

            <imp:importerHeader pages="${pages}" page="matchColumns" />

            <g:if test="${input!=null}">
                <p>The file <b>${input.originalFilename}</b> has been successfully read in.</p>
            </g:if>
            <g:form method="post" name="importData" action="importData">

                <table style="width: auto">
                    <tbody>
                    <g:each in="${text}" var="row" status="i">
                        <g:if test="${row.size()==0}">
                            <tr></tr>
                        </g:if>
                        <g:else>
                            <tr>
                                <td class="selectColumn">
                                    <g:if test="${i>0}">
                                        <input type="checkbox" name="row_${i}" CHECKED/>
                                    </g:if>
                                </td>


                                <g:each in="${row}" var="column" status="j">
                                    <td style="border: 1px solid lightgray;">

                                        <g:if test="${column.length()>25}">
                                            <div class="tooltip">
                                                ${column.substring(0,19)} &hellip;
                                                <span>
                                                    ${column}
                                                </span>
                                            </div>
                                        </g:if>
                                        <g:else>
                                            ${column}
                                        </g:else>

                                        <g:if test="${i==0}">
                                            <br/>
                                            <select id="column_${j}" name="column_${j}" onChange="selectChange();">
                                                <option value="">[Discard]</option>
                                                <g:each in="${templateFields}" var="tf" status="k">
                                                    <option value="${tf.name}">${tf.name}</option>
                                                </g:each>
                                            </select>
                                        </g:if>

                                    </td>
                                </g:each>
                            </tr>
                        </g:else>
                    </g:each>
                    </tbody>
                </table>

                <br />
                <imp:importerFooter>
                    <g:submitButton name="previous" value="« Previous" action="previous"/>
                    <g:submitButton name="next" value="Next »" action="next"/>
                </imp:importerFooter>
            </g:form>
        </div>
    </body>
</html>