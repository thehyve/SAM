// This JS contains templateField time/date related functionality, taken from GSCF's studyWizard.js.

function onStudyWizardPage() {
	// GENERAL
	attachDatePickers();
	attachDateTimePickers();
	disableKeys();
	disableDatePickerKeys();
}

// disable all key presses in every text element which has a datapicker
// attached
function disableDatePickerKeys() {
	$(".hasDatepicker").each(function() {
		$(this).bind('keydown', function(e) { return false; });
	});
}

// add datepickers to date fields
function attachDatePickers() {
	$("input[type=text][rel$='date']").each(function() {
		$(this).datepicker({
			changeMonth : true,
			changeYear  : true,
			/*numberOfMonths: 3,*/
			showButtonPanel: true,
			dateFormat  : 'dd/mm/yy',
			yearRange   : 'c-80:c+20',
			altField	: '#' + $(this).attr('name') + 'Example',
			altFormat   : 'DD, d MM, yy'
		});
	});
}

// add datetimepickers to date fields
function attachDateTimePickers() {
	$("input[type=text][rel$='datetime']").each(function() {
		$(this).datepicker({
			changeMonth	 : true,
			changeYear	  : true,
			dateFormat	  : 'dd/mm/yy',
			altField		: '#' + $(this).attr('name') + 'Example',
			altTimeField	: '#' + $(this).attr('name') + 'Example2',
			altFormat	   : 'DD, d MM, yy',
			showTime		: true,
			time24h		 : true
		});
	});
}

function disableKeys() {
	// disable enter key in input boxes to make sure
	// accidental submits do not happen
	$('input:text').each(function() {
		$(this).bind('keypress', function(e) {
			if (e.keyCode == 13) {
				return false;
			}
		});
	});
}

// insert add / modify option in template menu
function insertSelectAddMore() {
    new SelectAddMore().init({
        rel  : 'template',
        url  : baseUrl + '/templateEditor',
        vars        : 'entity,ontologies',
        label   : 'add / modify',
        style   : 'modify',
        onClose : handleTemplateChange
    });
}

var entityName;
var formSection;

//var handleTemplateChange = function (entityName, formSection) {
    var handleTemplateChange = function (selectedOption) {
        var templateEditorHasBeenOpened = false

        if( selectedOption == undefined ) {
            // If no selectedOptions is given, the template editor has been opened. In that case, we use
            // the template previously selected
            templateEditorHasBeenOpened = true;
        } else if( $(selectedOption).hasClass( 'modify' ) ){
            // If the user has selected the add/modify option, the form shouldn't be updated yet.
            // That should only happen if the template editor is closed
            return;
        }

        // Collect all data to be sent to the controller
        data = $( formSection ).serialize() + "&templateEditorHasBeenOpened=" + ( templateEditorHasBeenOpened ? "true" : "false" );

        // Always update the template specific fields, when the template has changed but also
        // when the template editor is closed
        $.ajax({
            url: baseUrl + "/" + entityName + "/returnUpdatedTemplateSpecificFields",
            data: data,
            type: "POST",
            success: function( returnHTML, textStatus, jqXHR ) {
                $( "#templateSpecific" ).html( returnHTML );
                onStudyWizardPage(); // Add datepickers

                // Update the template select only if the template has been closed
                // This can only happen after the previous call has succeeded, because
                // otherwise Hibernate will show up with a 'collection associated with
                // two open sessions' error.
                if( templateEditorHasBeenOpened ) {
                    $.ajax({
                        url: baseUrl + "/" + entityName + "/templateSelection",
                        data: data,
                        type: "POST",
                        success: function( returnHTML, textStatus, jqXHR ) {
                            $( "td#templateSelection" ).html( returnHTML );
                            insertSelectAddMore();
                        }
                    });
                }

            }
        });
    };
    //return handleFunction;
//};
