<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'measurement.label', default: 'Measurement')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
</head>

<body>
  	<content tag="contextmenu">
  		<li><g:link controller="measurement">List measurements</g:link></li>
  		<li><g:link controller="measurement" action="create">Create new measurement</g:link></li>
  	</content>

    <h1><g:message code="default.list.label" args="[entityName]"/></h1>
    
	<div class="data">
	    <div class="list">
	        <table class="datatables paginate sortable filter">
	            <thead>
	            <tr>
	                <th>Id</th>
	                <th>Value</th>
	                <th>Operator</th>
	                <th>Comments</th>
	
	                <th><g:message code="measurement.sample.label" default="Sample"/></th>
	
	                <th><g:message code="measurement.feature.label" default="Feature"/></th>
	
	            </tr>
	            </thead>
	            <tbody>
	            <g:each in="${measurementInstanceList}" status="i" var="measurementInstance">
	                <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
	
	                    <td><g:link action="show"
	                                id="${measurementInstance.id}">${fieldValue(bean: measurementInstance, field: "id")}</g:link></td>
	
	                    <td>${fieldValue(bean: measurementInstance, field: "value")}</td>
	
	                    <td>${fieldValue(bean: measurementInstance, field: "operator")}</td>
	
	                    <td>${fieldValue(bean: measurementInstance, field: "comments")}</td>
	
	                    <td>${fieldValue(bean: measurementInstance, field: "sample")}</td>
	
	                    <td>${fieldValue(bean: measurementInstance, field: "feature")}</td>
	
	                </tr>
	            </g:each>
	            </tbody>
	        </table>
	    </div>
	    
	    <ul class="data_nav buttons">
	    	<li><g:link controller="measurement" action="create" class="create">Add</g:link></li>
	    	<li><g:link controller="measurement" action="edit" class="edit">Edit</g:link></li>
	    	<li><g:link controller="measurement" action="deleteMultiple" class="delete">Delete</g:link></li>
	    </ul>
	</div>
	
</body>
</html>
