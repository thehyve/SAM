import org.codehaus.groovy.grails.web.json.JSONObject

class BootStrap {

    def init = { servletContext ->
        // Register your reader here, like this:
        // MatrixImporter.getInstance().registerReader( new ExcelReader() );
		
		// JSON null objects should return false if 
		// casted to boolean. This make life much easier
		JSONObject.NULL.metaClass.asBoolean = {-> false}

        try {
            if(org.codehaus.groovy.grails.commons.ConfigurationHolder.config.module.showVersionInfo) {
                new File("grails-app/views/_version.gsp").text = "hg id -i".execute().text;
            }
        } catch (Exception e) {
            println("BootStrap.groovy Error: "+e);
        }
    }
    def destroy = {
    }
}
