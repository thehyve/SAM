<%@ page import="org.dbxp.moduleBase.Study; org.dbxp.moduleBase.Assay" %>
<html>
    <head>
        <meta name="layout" content="main"/>
        <title>Measurement importer</title>
        <script type="text/javascript">
			// Associative array of booleans representing the state of the
			// select boxes 
    		var selectsOK = new Array();
        	
            $(document).ready(function() {
                new SelectAddMore().init({
                    rel  : 'featureSelector',
                    url  : baseUrl + '/feature/minimalCreate',
                    label   : 'Create a new feature',
                    style   : 'modify',
                    onClose : function(scope) {
						// Check the option ids of the options currently in the database
						ids = new Array();

						// Retrieve a list of all features to be put in the selects
                        $.getJSON(
                            baseUrl + "/feature/ajaxList",
                            function(data){
                                var options = '';
                                var features = data.features

                                // Create a list of options
                                for (var i = 0; i < features.length; i++) {
                                    options += '<option value="' + features[i].id + '">' + features[i].name + '</option>';
                                }
                                
                                $("select[rel*='featureSelector']").each( function( index, select ) {
                                    $select = $(select);
                                    
                                    // Update the list of items for each select. We have to keep the same values selected
                                    // so we remember the value of the selected item
                                    selection = $select.val();

                                    // Store the add/modify option
                                    var addModifyOption = $( 'option:last-child', $select );
                                    var discardOption = $( 'option:first-child', $select );

									// Check the number of features currently in the list
									var numFeatures = $( 'option', $select ).length - 2; // addModify and discard option 
                                    
									// Set the new options in the list
									$select.html( options );

                                   	// Add the add/modify and discard options back again
                                   	$select.append( addModifyOption );
									$select.prepend( discardOption );
									
									// Select the previously selected item. If nothing was selected, select the 
									// one that was added last 
									if( selection != undefined && selection != "" ) {
										// Select previously selected option
										$( 'option[value=' + selection + ']', $select ).attr( 'selected', true );
									} else if( numFeatures < features.length ){
										// Select feature last added
										$( 'option[value=' + data.last.id + ']', $select ).attr( 'selected', true );
									} else {
										// Select discard option
										$( 'option:first-child', $select ).attr( 'selected', true );
									}
                                });

                				<g:if test="${layout == 'sample_layout'}">
                					// Check if duplicate values are selected
            	                	selectChange('featureSelect');
            	                </g:if>
            	                <g:else>
            	                	// Check if maybe the add/modify option has been selected
									checkSelectValue('featureSelect');
								</g:else>
                            }
                        );
                    }
                });

				<g:if test="${layout == 'sample_layout'}">
	                selectChange('featureSelect');
    	            selectChange('sampleSelect');
    	        </g:if>
    	        <g:else>
	                selectChange('subjectSelect');
    	        </g:else>
            });

            function selectChange(type) {
                listSelects = $( 'select.' + type );
                
                var mapSelected = new Object();
                for(i=0; i<listSelects.length; i++) {
                    val = listSelects[ i ].value;

					// Value is "" if 'add/modify' is selected. Value is "null" if [discard] option is selected
                    if( val!="" && val != "null" ) {
                        if(mapSelected[val]==null) {
                            mapSelected[val] = 1;
                        } else {
                            mapSelected[val]++;
                        }
                    }
                }

				var blnOK = true;
                
				// Loop through all selects and mark the ones red that have
				// been selected multiple times
                for(i=0; i<listSelects.length; i++) {
                    val = listSelects[ i ].value;
                    listSelects[ i ].style.color = '';
                    if(val!="null") {
                        if(mapSelected[val] > 1 || val == "" ) {
                            listSelects[ i ].style.color = 'red';
                            blnOK = false;
                        }
                    }
                }

                selectsOK[ type ] = blnOK;

                toggleNextButton();
            }

            function toggleNextButton() {
				var globalOK = true;
				for( type in selectsOK ) {
					if( !selectsOK[ type ] ) {
						globalOK = false;
						break;
					}
				}

                $( '#_eventId_next' ).attr( 'disabled', !globalOK );
            }

            function checkSelectValue(type) {
                // Loop through all selects and mark the ones red that have
				// 'Create new feature' as their selected values
                listSelects = $( 'select.' + type );
				var blnOK = true;
                for(i=0; i<listSelects.length; i++) {
                    val = listSelects[ i ].value;
                    listSelects[ i ].style.color = '';
                    if(val=="") {
                        listSelects[ i ].style.color = 'red';
                        blnOK = false;
                    }
                }
                selectsOK[ type ] = blnOK;
                toggleNextButton();
            }
        </script>
        
        <r:require module="importer" />
    </head>
    <body>
        <content tag="contextmenu">
            <g:render template="contextmenu" />
        </content>
        <h1>${test}</h1>
        <div class="data">

            <imp:importerHeader pages="${pages}" page="selectColumns" />

            <g:if test="${message}">
                <div class="errors">${message}</div>
                <br />
            </g:if>

            <p>
                You have chosen the <g:if test="${layout=='sample_layout'}">sample layout</g:if><g:if test="${layout=='subject_layout'}">subject layout</g:if>. On this page, we have tried to match your data with our data. You must double check these matches, and confirm your final choice.
            </p>
            <g:if test="${blnPassedSelectColumns==true}">
                <p class='message'>
                    Please note: changes that have been made on the next page ('Confirm Input') are not reflected on this page. However, they will be available to you again on the next page. On this page the original file contents are being shown.
                </p>
            </g:if>
            
            <%--
            	Unfortunately, within the webflow, we cannot pass variables to the view (as you do 
            	normally by render( view: '', model: [...])). For that reason, we retrieve the list of
            	features from the database here. That way, if the user refreshes the page, all features
            	are read from the database (also the ones previously added).
             --%>
             <% features = org.dbxp.sam.Feature.list( sort: "name" ); %>
            
            <form method="post">
                <g:if test="${layout=='sample_layout'}">
                    <table style="width: auto">
                        <g:each in="${text}" var="row" status="i">
                            <g:if test="${row?.size()==0}">
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
                                                        <g:if test="${edited_text != null}">
                                                            <g:if test="${edited_text[i][j]!=null}">
                                                            	<g:set var="featureValue" value="${edited_text[i][j].id}" />
                                                            </g:if>
                                                            <g:else>
                                                            	<g:set var="featureValue" value="" />
                                                            </g:else>
                                                        </g:if>
                                                        <g:else>
                                                           	<g:set var="featureValue" value="${features[feature_matches[column]].id}" />
                                                        </g:else>
                                                        
                                                        <g:select rel="featureSelector" name="${i},${j}" from="${features}" value="${featureValue}" optionKey="id" optionValue="name" noSelection="[null:'[Discard]']" class="importerSelect featureSelect" onchange="selectChange('featureSelect');"/>
                                                    </div>
                                                </g:if>
                                                <g:if test="${j==0}">
                                                    <br>
                                                    <!-- Sample row -->
                                                    <div class="importerSelectBackground">
                                                        <g:if test="${edited_text!=null}">
                                                            <g:if test="${edited_text[i][j]!=null}">
                                                            	<g:set var="sampleValue" value="${edited_text[i][j].id}" />
                                                            </g:if>
                                                            <g:else>
                                                            	<g:set var="sampleValue" value="" />
                                                            </g:else>
                                                        </g:if>
                                                        <g:else>
                                                          	<g:set var="sampleValue" value="${samples[sample_matches[column]].id}" />
                                                        </g:else>

                                                        <g:select name="${i},${j}" from="${samples}" value="${sampleValue}" optionKey="id" optionValue="name" noSelection="[null:'[Discard]']" class="importerSelect sampleSelect" onchange="selectChange('sampleSelect');"/>

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
                            <g:if test="${row?.size()==0}">
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
                                                            <g:select rel="featureSelector" name="${i},${j}" from="${features}" value="${edited_text[i][j].id}" optionKey="id" optionValue="name" noSelection="[null:'[Discard]']" class="importerSelect featureSelect"/>
                                                        </g:if>
                                                        <g:else>
                                                            <g:select rel="featureSelector" name="${i},${j}" from="${features}" value="" optionKey="id" optionValue="name" noSelection="[null:'[Discard]']" class="importerSelect featureSelect"/>
                                                        </g:else>
                                                    </g:if>
                                                    <g:else>
                                                        <g:select rel="featureSelector" name="${i},${j}" from="${features}" value="${features[feature_matches[column]].id}" optionKey="id" optionValue="name" noSelection="[null:'[Discard]']" class="importerSelect featureSelect"/>
                                                    </g:else>
                                                </g:if>
                                                <g:if test="${i==1&&j>0}">
                                                    <!-- Timepoint row -->
                                                    <g:if test="${edited_text!=null}">
                                                        <g:if test="${edited_text[i][j]!=null}">
                                                            <g:select name="${i},${j}" from="${timepoints}" value="${edited_text[i][j]}" noSelection="[null:'[Discard]']" class="importerSelect timepointSelect"/>
                                                        </g:if>
                                                        <g:else>
                                                            <g:select name="${i},${j}" from="${timepoints}" value="" noSelection="[null:'Discard']" class="importerSelect timepointSelect"/>
                                                        </g:else>
                                                    </g:if>
                                                    <g:else>
                                                        <g:select name="${i},${j}" from="${timepoints}" value="${timepoints[timepoint_matches[column]]}" noSelection="[null:'[Discard]']" class="importerSelect timepointSelect"/>
                                                    </g:else>
                                                </g:if>
                                                <g:if test="${j==0 && i>1}">
                                                    <!-- Subject row -->
                                                    <g:if test="${edited_text!=null}">
                                                        <g:if test="${edited_text[i][j]!=null}">
                                                            <g:select name="${i},${j}" from="${subjects}" value="${edited_text[i][j]}" noSelection="[null:'[Discard]']" class="importerSelect subjectSelect" onchange="selectChange('subjectSelect');"/>
                                                        </g:if>
                                                        <g:else>
                                                            <g:select name="${i},${j}" from="${subjects}" value="" noSelection="[null:'[Discard]']" class="importerSelect subjectSelect" onchange="selectChange('subjectSelect');"/>
                                                        </g:else>
                                                    </g:if>
                                                    <g:else>
                                                        <g:select name="${i},${j}" from="${subjects}" value="${subjects[subject_matches[column]]}" noSelection="[null:'[Discard]']" class="importerSelect subjectSelect" onchange="selectChange('subjectSelect');"/>
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
                <imp:importerFooter>
                    <g:submitButton name="previous" value="« Previous" action="previous"/>
                    <g:submitButton name="next" value="Next »" action="next"/>
                </imp:importerFooter>
            </form>            

        </div>
    </body>
</html>