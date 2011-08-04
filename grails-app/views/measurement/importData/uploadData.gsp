<%@ page import="org.dbxp.moduleBase.Study; org.dbxp.moduleBase.Assay" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Measurement importer</title>

        <r:script type="text/javascript" disposition="head">
        function createTextfield(id) {
            $( "#"+id ).html("<br /><br /><textarea id='"+id+"' name='"+id+"' rows='5' cols='20'></textarea>");
            $( "#"+id ).resizable({
                handles: "se"
            });
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
            <h1>Upload your file</h1>
            <g:if test="${message}">
                <br>
                <span class="errors">${message}</span>
                <br>
            </g:if>
            <p>The assay you selected is the assay <b>${assay.name}</b> from the study <b>${studyName}</b>. On this page you can upload the file containing the data you wish to add to this assay. Please make sure that the file in question has a structure that corresponds to one of the following two layout examples.</p>
            <!-- <div style="position:absolute; left: 0px; top: 120px;"> -->
            <div style="display: inline-block;">
                <h2>The sample layout:</h2>
                <br>
                <r:img uri="/images/samplelayout.png"/>
            </div>
            <!-- <div style="position:absolute; right: -150px; top: 120px;"> -->
            <div style="display: inline-block;">
                <h2>The subject layout:</h2>
                <br>
                <r:img uri="/images/subjectlayout.png"/>
            </div>
            <form method="post" enctype="multipart/form-data">
            <g:if test="${message}">
                <div class="errors" style="display: block;">
            </g:if>
            <g:else>
                <div style="display: block;">
            </g:else>
                    <h2>Locate the file on your computer:</h2>
                    <p>Make sure to add a comma-separated values based or Excel based file using the upload field below.</p>
                    <input id="file" type="file" id="fileUpload" name="fileUpload"/> <span id="pasteField">or <a href="#" onclick="createTextfield('pasteField'); return false;">paste in textfield</a></span>
                </div>
                <div style="display: block;">
                    <g:submitButton name="previous" value="Choose a different assay" action="previous"/>
                    <g:submitButton name="next" value="Upload file and continue importing" action="next"/>
                </div>
            </form>
        </div>
    </body>
</html>