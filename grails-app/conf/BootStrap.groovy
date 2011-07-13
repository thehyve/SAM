import org.dbxp.matriximporter.CsvReader
import org.dbxp.matriximporter.ExcelReader
import org.dbxp.matriximporter.MatrixImporter

class BootStrap {

    def init = { servletContext ->
        MatrixImporter.getInstance().registerReader( new CsvReader() );
        MatrixImporter.getInstance().registerReader( new ExcelReader() );
    }
    def destroy = {
    }
}
