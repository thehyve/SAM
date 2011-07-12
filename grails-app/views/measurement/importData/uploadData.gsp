<%--
  Created by IntelliJ IDEA.
  User: Workerbee
  Date: 12-7-11
  Time: 14:19
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head><title>Simple GSP page</title></head>
  <body>
    <%
        println params
    %>
  <hr>
    Assay:
    <%
        println flow?.assay
    %>
  <hr>
    Study:
    <%
        println flow?.study
    %>
  </body>
</html>