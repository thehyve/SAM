<g:if test="${flash.message}">
	<div class="errors">
		${flash.message}
	</div>
</g:if>
<table id="featureGroups_list">
   <g:each in="${groupList}" var="f" status="i">
	<tr class="prop ${(i % 2) == 0 ? 'odd' : 'even'}">
	
	    <td>
	        <g:link controller="featureGroup" action="show" id="${f?.featureGroup.id}">${f?.featureGroup.name.encodeAsHTML()}</g:link>
	    </td>
	    <td>
            <span class="buttons button">
	            <a href="#" class="buttons button delete" onclick="if( confirm('Are you sure?') ) { removeFromFeatureGroup(${f?.id}); }">
	                Remove from feature group
	            </a>
	        </span>
	    </td>
	</tr>
   </g:each>
   <g:if test="${remainingGroups?.size()}">
	    <tr>
	        <g:if test="${groupList?.size()}">
		        <td colspan="2" class="border-top">
		            Add this feature to another group
		        </td>
	        </g:if>
	        <g:else>
		        <td colspan="2">
		            This feature has not been added to any groups yet.
		        </td>
	        </g:else>
	    </tr>
	    <tr>
	        <td>
	            <g:select id="newFeatureGroup" name="newFeatureGroup" from="${remainingGroups}" optionKey="id" optionValue="name"/>
	        </td>
	        <td>
	            <span class="buttons button simpleButton">
	                <a name="confirmNewFeatureGroup" class="add" onclick="addToFeatureGroup();">
	                    Add feature to this group
	                </a>
	            </span>
	        </td>
	    </tr>
	</g:if>
	<g:else>
	    <tr>
	        <g:if test="${groupList?.size()}">
		        <td colspan="2" class="border-top">
		            There are no more groups this feature can be added to.
		        </td>
	        </g:if>
	        <g:else>
		        <td colspan="2">
		            There are no feature groups yet.
		        </td>
	        </g:else>
	    </tr>
	</g:else>
</table>
