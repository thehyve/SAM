import org.codehaus.groovy.grails.web.json.JSONObject

class BootStrap {

    def init = { servletContext ->
        // Register your reader here, like this:
        // MatrixImporter.getInstance().registerReader( new ExcelReader() );
		
		// JSON null objects should return false if 
		// casted to boolean. This make life much easier
		JSONObject.NULL.metaClass.asBoolean = {-> false}
    }
    def destroy = {
    }
}
