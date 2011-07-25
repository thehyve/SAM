<%--
  Created by IntelliJ IDEA.
  User: Workerbee
  Date: 12-7-11
  Time: 14:20
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
      <title>Your data has not been saved</title>
    </head>
    <body>
        <g:if test="${message}">
            <p class="message">${message.toString()}</p>
        </g:if>
        <g:if test="${error}">
            <p class="error">${error.toString()}</p>
        </g:if>
        <p>
            Please review the issue(s) and try again.
            You can use the 'previous' button to go back to the previous page.
            Please note that none of your data has been saved yet.
        </p>
        <form method="post" enctype="multipart/form-data">
            <g:hiddenField name="error" value="${error}"/>
            <g:hiddenField name="message" value="${message}"/>
            <g:submitButton name="previous" value="Choose a different assay" action="previous"/>
            <g:submitButton name="next" value="Upload file and continue importing" action="next"/>
        </form>
    </body>
</html>