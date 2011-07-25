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
            <p>The assay you selected is the assay <b>${assay.name}</b> from the study <b>${studyName}</b>. On this page you can upload the file containing the data you wish to add to this assay. Please make sure that the file in question has a structure that corresponds to one of the following two layout examples.</p>
            <table>
                <tr>
                    <td>
                        The sample layout:
                    </td>
                    <td>
                        The subject layout:
                    </td>
                </tr>
                <tr>
                    <td>
                        <table>
                            <tr>
                                <td></td>
                                <td><span style="color: darkgreen;">Feature name 1</span></td>
                                <td><span style="color: black;">Feature name 2</span></td>
                                <td><span style="color: lightseagreen;">Feature name 3</span></td>
                            </tr>
                            <tr>
                                <td><span style="color: purple;">Sample name 1</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                            </tr>
                            <tr>
                                <td><span style="color: purple;">Sample name 2</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                            </tr>
                            <tr><td><span style="color: purple;">Sample name 3</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <table>
                            <tr>
                                <td></td>
                                <td><span style="color: darkgreen;">Feature name 1</span></td>
                                <td><span style="color: darkgreen;">Feature name 1</span></td>
                                <td><span style="color: black;">Feature name 2</span></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><span style="color: peru;">Time point 1</span></td>
                                <td><span style="color: orange;">Time point 2</span></td>
                                <td><span style="color: peru;">Time point 1</span></td>
                            </tr>
                            <tr>
                                <td><span style="color: gray;">Subject name 1</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                            </tr>
                            <tr>
                                <td><span style="color: gray;">Subject name 2</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                            </tr>
                            <tr>
                                <td><span style="color: gray;">Subject name 3</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                                <td><span style="color: blue;">Measurement</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <br>
            <g:if test="${message}"><p><span class="errors">${message}</span>
                <div class="errors">
            </g:if>
            <g:else>
                <div>
            </g:else>
                <form method="post" enctype="multipart/form-data">
                    <h2>Locate the file on your computer:</h2>
                    <input id="file" type="file" id="fileUpload" name="fileUpload"/>
                    <br>
                    <br>
                    <g:submitButton name="previous" value="Choose a different assay" action="previous"/>
                    <g:submitButton name="next" value="Upload file and continue importing" action="next"/>
                </form>
            </div>
        </div>
    </body>
</html>