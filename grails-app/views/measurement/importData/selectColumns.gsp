<%@ page import="org.dbxp.moduleBase.Study; org.dbxp.moduleBase.Assay" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Measurement importer</title>
        <script type="text/javascript">
            $(document).ready(function() {
                new SelectAddMore().init({
                    rel  : 'featureSelector',
                    url  : baseUrl + '/feature/minimalCreate',
                    label   : 'Create a new feature',
                    style   : 'modify',
                    onClose : function(scope) {
                        $.getJSON(
                            baseUrl+"/feature/retrieveMissingOption?currentOptions=${features.id}",
                            function(j){
                                var options = '';
                                for (var i = 0; i < j.length; i++) {
                                    options += '<option value="' + j[i].id + '">' + j[i].name + '</option>';
                                }
                                $("select[rel*='featureSelector']").each(function() {
                                    //var magicSelect = $(this).find('option:contains(Create a new feature)')
                                    //$(this).find('option:contains(Create a new feature)').remove();
                                    $(this).append(options);
                                    //$(this).append(magicSelect);
                                });
                            }
                        );
                    }
                });

                selectChange('featureSelect');
                selectChange('sampleSelect');
                selectChange('subjectSelect');
                selectChange('timepointSelect');
            });

            function selectChange(type) {
                listSelects = $('select[class*='+type+']');
                var mapSelected = new Object();
                for(i=0; i<listSelects.length; i++) {
                    val = listSelects[ i ].value;
                    if(val!="" && val!="null") {
                        if(mapSelected[val]==null) {
                            mapSelected[val] = 1;
                        } else {
                            mapSelected[val]++;
                        }
                    }
                }

                for(i=0; i<listSelects.length; i++) {
                    val = listSelects[ i ].value;
                    listSelects[ i ].style.color = '';
                    if(val!="" && val!="null") {
                        if(mapSelected[val]>1) {
                            listSelects[ i ].style.color = 'red';
                        }
                    }
                }
            }
        </script>
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
            <g:if test="${blnPassedSelectColumns==true}">
                <p class='message'>
                    Please note: changes that have been made on the next page ('Confirm Input') are not reflected on this page. However, they will be available to you again on the next page. On this page the original file contents are being shown.
                </p>
            </g:if>
            <form method="post">
                <g:if test="${layout=='sample_layout'}">
                    <table style="width: auto">
                        <g:each in="${text}" var="row" status="i">
                            <g:if test="${row.size()==0}">
                                <tr></tr>
                            </g:if>
                            <g:else>
                                <tr>
                                    <g:each in="${row}" var="column" status="j">
                                        <g:if test="${!(i==0&j==0)}">
                                            <td class="
                                            <g:if test="${(i==0&&j>0) || (j==0)}">
                                                importerHeader">
                                            </g:if>
                                            <g:else>
                                                importerCell">
                                            </g:else>
                                                <div
                                                <g:if test="${column.length()>25}">
                                                     class="tooltip importerInteractiveCell">
                                                        ${column.substring(0,19)} &hellip;
                                                        <span>
                                                            ${column}
                                                        </span>
                                                </g:if>
                                                <g:else>
                                                    >${column}
                                                </g:else>
                                                <g:if test="${i==0&&j>0}">
                                                    <br>
                                                    <!-- Feature row -->
                                                    <div class="importerSelectBackground">
                                                        <g:if test="${edited_text!=null}">
                                                            <g:if test="${edited_text[i][j]!=null}">
                                                                <g:select rel="featureSelector" name="${i},${j}" from="${features}" value="${edited_text[i][j].id}" optionKey="id" optionValue="name" noSelection="[null:'Discard']" class="importerSelect featureSelect" onchange="selectChange('featureSelect');"/>
                                                            </g:if>
                                                            <g:else>
                                                                <g:select rel="featureSelector" name="${i},${j}" from="${features}" value="" optionKey="id" optionValue="name" noSelection="[null:'Discard']" class="importerSelect featureSelect" onchange="selectChange('featureSelect');"/>
                                                            </g:else>
                                                        </g:if>
                                                        <g:else>
                                                            <g:select rel="featureSelector" name="${i},${j}" from="${features}" value="${features[feature_matches[column]].id}" optionKey="id" optionValue="name" noSelection="[null:'Discard']" class="importerSelect featureSelect" onchange="selectChange('featureSelect');"/>
                                                        </g:else>
                                                    </div>
                                                </g:if>
                                                <g:if test="${j==0}">
                                                    <br>
                                                    <!-- Sample row -->
                                                    <div class="importerSelectBackground">
                                                        <g:if test="${edited_text!=null}">
                                                            <g:if test="${edited_text[i][j]!=null}">
                                                                <g:select name="${i},${j}" from="${samples}" value="${edited_text[i][j].id}" optionKey="id" optionValue="name" noSelection="[null:'Discard']" class="importerSelect sampleSelect" onchange="selectChange('sampleSelect');"/>
                                                            </g:if>
                                                            <g:else>
                                                                <g:select name="${i},${j}" from="${samples}" value="" optionKey="id" optionValue="name" noSelection="[null:'Discard']" class="importerSelect sampleSelect" onchange="selectChange('sampleSelect');"/>
                                                            </g:else>
                                                        </g:if>
                                                        <g:else>
                                                            <g:select name="${i},${j}" from="${samples}" value="${samples[sample_matches[column]].id}" optionKey="id" optionValue="name" noSelection="[null:'Discard']" class="importerSelect sampleSelect" onchange="selectChange('sampleSelect');"/>
                                                        </g:else>
                                                    </div>
                                                </g:if>
                                                </div>
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
                <g:else>
                    <table style="width: auto">
                        <g:each in="${text}" var="row" status="i">
                            <g:if test="${row.size()==0}">
                                <tr></tr>
                            </g:if>
                            <g:else>
                                <tr>
                                    <g:each in="${row}" var="column" status="j">
                                        <g:if test="${!(i==0&j==0)}">
                                            <td class="
                                                <g:if test="${(i==0&&j>0) || (i==1&&j>0) || (j==0 && i>1)}">
                                                    importerHeader">
                                                </g:if>
                                                <g:else>
                                                    importerCell">
                                                </g:else>
                                                <g:if test="${column.length()>25}">
                                                    <div class="tooltip importerInteractiveCell">
                                                        ${column.substring(0,19)} &hellip;
                                                        <span>
                                                            ${column}
                                                        </span>
                                                    </div>
                                                </g:if>
                                                <g:else>
                                                    ${column}
                                                </g:else>
                                                <g:if test="${i==0&&j>0}">
                                                    <!-- Feature row -->
                                                    <g:if test="${edited_text!=null}">
                                                        <g:if test="${edited_text[i][j]!=null}">
                                                            <g:select rel="featureSelector" name="${i},${j}" from="${features}" value="${edited_text[i][j].id}" optionKey="id" optionValue="name" noSelection="[null:'Discard']" class="importerSelect featureSelect" onchange="selectChange('featureSelect');"/>
                                                        </g:if>
                                                        <g:else>
                                                            <g:select rel="featureSelector" name="${i},${j}" from="${features}" value="" optionKey="id" optionValue="name" noSelection="[null:'Discard']" class="importerSelect featureSelect" onchange="selectChange('featureSelect');"/>
                                                        </g:else>
                                                    </g:if>
                                                    <g:else>
                                                        <g:select rel="featureSelector" name="${i},${j}" from="${features}" value="${features[feature_matches[column]].id}" optionKey="id" optionValue="name" noSelection="[null:'Discard']" class="importerSelect featureSelect" onchange="selectChange('featureSelect');"/>
                                                    </g:else>
                                                </g:if>
                                                <g:if test="${i==1&&j>0}">
                                                    <!-- Timepoint row -->
                                                    <g:if test="${edited_text!=null}">
                                                        <g:if test="${edited_text[i][j]!=null}">
                                                            <g:select name="${i},${j}" from="${timepoints}" value="${edited_text[i][j]}" noSelection="[null:'Discard']" class="importerSelect timepointSelect" onchange="selectChange('timepointSelect');"/>
                                                        </g:if>
                                                        <g:else>
                                                            <g:select name="${i},${j}" from="${timepoints}" value="" noSelection="[null:'Discard']" class="importerSelect timepointSelect" onchange="selectChange('timepointSelect');"/>
                                                        </g:else>
                                                    </g:if>
                                                    <g:else>
                                                        <g:select name="${i},${j}" from="${timepoints}" value="${timepoints[timepoint_matches[column]]}" noSelection="[null:'Discard']" class="importerSelect timepointSelect" onchange="selectChange('timepointSelect');"/>
                                                    </g:else>
                                                </g:if>
                                                <g:if test="${j==0 && i>1}">
                                                    <!-- Subject row -->
                                                    <g:if test="${edited_text!=null}">
                                                        <g:if test="${edited_text[i][j]!=null}">
                                                            <g:select name="${i},${j}" from="${subjects}" value="${edited_text[i][j]}" noSelection="[null:'Discard']" class="importerSelect subjectSelect" onchange="selectChange('subjectSelect');"/>
                                                        </g:if>
                                                        <g:else>
                                                            <g:select name="${i},${j}" from="${subjects}" value="" noSelection="[null:'Discard']" class="importerSelect subjectSelect" onchange="selectChange('subjectSelect');"/>
                                                        </g:else>
                                                    </g:if>
                                                    <g:else>
                                                        <g:select name="${i},${j}" from="${subjects}" value="${subjects[subject_matches[column]]}" noSelection="[null:'Discard']" class="importerSelect subjectSelect" onchange="selectChange('subjectSelect');"/>
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
                </g:else>
                <g:submitButton name="previous" value="Previous" action="previous"/>
                <g:submitButton name="next" value="Next" action="next"/>
            </form>
        </div>
    </body>
</html>