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
            <h1>Upload your file</h1>
            <p>The assay you selected is the assay <span style="color: red;">${assayName}</span> from the study <span style="color: red;">${studyName}</span>. On this page you can upload the file containing the data you wish to add to this assay. Please make sure that the file in question has a structure that corresponds to one of the following two layout examples.</p>
            <ul>
                <li> The sample layout:
                    <table>
                        <tr>
                            <td></td>
                            <td><span style="color: darkgreen;">Feature name 1</span></td>
                            <td><span style="color: black;">Feature name 2</span></td>
                            <td><span style="color: lightseagreen;">Feature name 3</span></td>
                        </tr>
                        <tr>
                            <td><span style="color: purple;">Sample name</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                        </tr>
                        <tr>
                            <td><span style="color: purple;">Sample name</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                        </tr>
                        <tr><td><span style="color: purple;">Sample name</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                        </tr>
                    </table>
                </li>
                <li> The subject layout:
                    <table>
                        <tr>
                            <td></td>
                            <td><span style="color: darkgreen;">Feature name 1</span></td>
                            <td><span style="color: darkgreen;">Feature name 1</span></td>
                            <td><span style="color: black;">Feature name 2</span></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><span style="color: peru;">Time point</span></td>
                            <td><span style="color: peru;">Time point</span></td>
                            <td><span style="color: peru;">Time point</span></td>
                        </tr>
                        <tr>
                            <td><span style="color: gray;">Subject name</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                        </tr>
                        <tr>
                            <td><span style="color: gray;">Subject name</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                        </tr>
                        <tr>
                            <td><span style="color: gray;">Subject name</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                            <td><span style="color: blue;">Measurement</span></td>
                        </tr>
                    </table>
                </li>
            </ul>
            <g:if test="${message}"><p><span class="errors">${message}</span>
                <div class="errors">
            </g:if>
            <g:else>
                <div>
            </g:else>
                <form method="post" enctype="multipart/form-data">
                    <input id="file" type="file" id="fileUpload" name="fileUpload"/>
                    <br>
                    <g:submitButton name="previous" value="Previous" action="previous"/>
                    <g:submitButton name="next" value="Upload file and continue importing" action="next"/>
                </form>
            </div>
        </div>
    </body>
</html>