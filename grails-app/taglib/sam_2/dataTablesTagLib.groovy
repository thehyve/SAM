package sam_2

class dataTablesTagLib {

    def dataTable = {attrs, body ->

        if(attrs.id == null)
            throwTagError("Tag [datatablesForm] is missing required attribute [id]");

        out << "<form name='"+attrs.id+"_form' id='"+attrs.id+"_form'>";

        Map mapInputs = attrs.inputs;
        mapInputs.each { item ->
            out << "<input type='hidden' id='"+item.key +"' value='"+ item.value +"' />";
        }
        out << "</form>";

        String strClass="";
        if(!attrs.class == null)
            strClass = " " + attrs.class;

        out << "<table id='"+attrs.id+"_table' class='datatables"+strClass+"'>";
        out << body{};
        out << "</table>";
    }

    def buttonsViewEditDelete = {attrs ->

        if(attrs.mapEnabled == null) {
            // By default all buttons are enabled
            attrs.mapEnabled = [blnShow: true, blnEdit: true, blnDelete: true];
        }

        out << "<td class='buttonColumn'>";
        if(attrs.mapEnabled.blnShow) {
            out << g.link(action:"show", class:"show", controller:attrs.controller, id:attrs.id, "<img src=\"${fam.icon( name: 'magnifier')}\" alt=\"show\"/>");
        } else {
            out << "<img class='disabled' src=\"${fam.icon( name: 'magnifier')}\" alt=\"show\"/>";
        }
        out << "</td><td class='buttonColumn'>";
        if(attrs.mapEnabled.blnEdit) {
            out << g.link(action:"edit", class:"edit", controller:attrs.controller, id:attrs.id, "<img src=\"${fam.icon( name: 'pencil')}\" alt=\"edit\"/>");
        } else {
            out << "<img class='disabled' src=\"${fam.icon( name: 'pencil')}\" alt=\"edit\"/>";
        }
        out << "</td><td class='buttonColumn'>";
        if(attrs.mapEnabled.blnDelete) {
        out << g.link(action:"delete", class:"delete", onclick:"if(confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}')) {\$('#id').val(${attrs.id}); \$('#deleteForm').submit(); return false;} else {return false;} ;", controller:attrs.controller, "<img src=\"${fam.icon( name: 'delete')}\" alt=\"delete\"/>");
        } else {
            out << "<img class='disabled' src=\"${fam.icon( name: 'delete')}\" alt=\"delete\"/>";
        }
        out << "</td>";

	}

    def buttonsHeader = {attrs ->
        // This tag generates a number of empty headers (default=3)
        //
        // Usage:
        // <g:buttonsHeader/>
        // <g:buttonsHeader numColumns="2"/>

        if(attrs.numColumns == null) {
            // Default = 3
            attrs.numColumns = 3;
        } else {
            attrs.numColumns = Integer.valueOf(attrs.numColumns);
        }

        for(int i=0; i<attrs.numColumns; i++) {
            out << '<th class="nonsortable buttonColumn"></th>';
        }

    }

}
