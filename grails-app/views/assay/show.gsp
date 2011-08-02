<%@ page import="org.dbxp.moduleBase.Study" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'study.label', default: 'Study')}" />
        <title>Show assay ${assayInstance.name}</title>
    </head>
    <body>
		<h1>${assayInstance.name} / ${assayInstance.study.name}</h1>
		
		<g:if test="${measurements.size() > 0}">
			<table>
				<thead>
					<tr>
						<th></th>
						<g:each var="feature" in="${features}">
							<th>${feature.name}</th>
						</g:each>
					</tr>
				</thead>
				<tbody>
					<% def emptySamples = 0; %>
					<g:each var="sample" in="${samples}">
						<% def sampleFilled = measurements.any { it.sample.id == sample.id } %>
						<g:if test="${!hideEmpty || sampleFilled}">
							<tr>
								<td>${sample.name}</td>
								
								<g:each var="feature" in="${features}">
									<% def found = measurements.find { it.sample.id == sample.id && it.feature.id == feature.id } %>
									<td class="${found?.comments ? 'comments tooltip' : ''}">
										<g:if test="${found}">
											<g:if test="${found.operator}">${found.operator}</g:if>
											${found.value}
											
											<g:if test="${found.comments}">
												<span>
													${found.comments.encodeAsHTML()}
												</span>
											</g:if>
										</g:if>
									</td>
								</g:each>
							</tr>
						</g:if>
						<g:else>
							<% emptySamples++ %>
						</g:else>
					</g:each>
				</tbody>
			</table>
			<g:if test="${hideEmpty}">
				<g:if test="${emptySamples > 0}">
					<p>
						${emptySamples} sample(s) are now shown because they have no measurements. 
						Click <g:link action="show" params="['id': assayInstance.id, 'hideEmpty': false]">here</g:link> to show all.
					</p>
				</g:if>
			</g:if>
			<g:else>
				<p>
					Click <g:link action="show" params="['id': assayInstance.id, 'hideEmpty': true]">here</g:link> to hide samples without measurements.
				</p>
			</g:else>
		</g:if>
		<g:else>
			<p>
				No measurements were found for this assay. Use the <g:link controller="measurement" action="importData">importer</g:link> 
				to import your data	or add your measurements <g:link controller="measurement" action="create">manually</g:link>.
			</p>
		</g:else>
    </body>
</html>
