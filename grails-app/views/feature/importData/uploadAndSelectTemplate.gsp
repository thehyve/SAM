<%@ page import="org.dbxp.sam.Feature; org.dbnp.gdt.Template" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Feature importer</title>
        <r:script type="text/javascript" disposition="head">
            $(document).ready(function() {
                insertSelectAddMore();
            });

            function insertSelectAddMore() {
                new SelectAddMore().init({
                    rel  : 'template',
                    url  : baseUrl + '/templateEditor',
                    vars    : 'entity,ontologies',
                    label   : 'add / modify',
                    style   : 'modify',
                    onClose : function(scope) {
                        $.ajax({
                            url: baseUrl + "/feature/templateSelection",
                            success: function( returnHTML, textStatus, jqXHR ) {
                                $( "td#templateSelection" ).html( returnHTML );
                                insertSelectAddMore();
                            }
                        });
                    }
                });
            }

            function createTextfield(id) {
                $( "#"+id ).html("<br /><br /><textarea id='"+id+"' name='"+id+"' rows='5' cols='20'></textarea>");
                $( "#"+id ).resizable({
                    handles: "se"
                });
            }

            function handleTemplateChange() {
                // Javascript that is executed when a template is selected
                // Do nothing
            }

        </r:script>
    </head>
    <body>
        <content tag="contextmenu">
            <li><g:link class="list" controller="feature">List features</g:link></li>
            <li><g:link class="create" controller="feature" action="create">Create new feature</g:link></li>
            <li><g:link class="import" controller="feature" action="importData">Import</g:link></li>
            <li><g:link class="list" controller="featureGroup">List feature groups</g:link></li>
        </content>
        <div class="data">
            <h1>Importer wizard</h1>
            <p>You can import your Excel data to the server by choosing a file from your local harddisk in the form below. </p>

            <g:if test="${message}">
                <div class="errors">${message}</div><br />
            </g:if>
            <div>
                <g:form method="post" enctype="multipart/form-data" name="importData" action="importData">
                    <table>
                        <tbody>
                            <tr>
                                <td width="100px">Choose your Excel file to import:</td>
                                <td width="100px"><input type="file" id="fileUpload" name="fileUpload"/> <span id="pasteField">or <a href="#" onclick="createTextfield('pasteField'); return false;">paste in textfield</a></span></td>
                            </tr>
                            <tr>
                                <td><div id="datatemplate">Choose type of data template: </div></td>
                                <td id="templateSelection">
                                    <af:templateElement name="template" rel="template" description="" entity="${Feature}" ontologies="" value="" error="template" addDummy="true" onChange="if(!\$( 'option:selected', \$(this) ).hasClass( 'modify' )){ }"></af:templateElement>
                                </td>
                            </tr>
                        </tbody>

                    </table>
                    <br />
                    <g:submitButton name="next" value="Upload file and continue importing" onClick="return !\$('option:selected', \$('#template') ).hasClass( 'modify' );" action="next"/>

                </g:form>
            </div>
        </div>
    </body>
</html>