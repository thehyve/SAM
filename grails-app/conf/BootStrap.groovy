import org.dbxp.matriximporter.CsvReader
import org.dbxp.matriximporter.ExcelReader
import org.dbxp.matriximporter.MatrixImporter

class BootStrap {

    def init = { servletContext ->
        // Register your reader here, like this:
        // MatrixImporter.getInstance().registerReader( new ExcelReader() );
    }
    def destroy = {
    }
}
