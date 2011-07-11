package sam_2

class VieweditdeleteTagLib {

    def buttonsViewEditDelete = {attrs ->

        out << g.link(action:"show", class:"show", controller:attrs.controller, id:attrs.id, "<img src=\"${fam.icon( name: 'magnifier')}\" alt=\"show\"/>");
        out << " ";
        out << g.link(action:"edit", class:"edit", controller:attrs.controller, id:attrs.id, "<img src=\"${fam.icon( name: 'pencil')}\" alt=\"edit\"/>");
        out << " ";
        out << g.link(action:"delete", class:"delete", onclick:"if(confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}')) {\$('#id').val(${attrs.id}); \$('#deleteForm').submit(); return false;} else {return false;} ;", controller:attrs.controller, "<img src=\"${fam.icon( name: 'delete')}\" alt=\"delete\"/>");

	}

}
