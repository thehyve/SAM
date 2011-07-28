package org.dbxp.sam
import org.dbxp.moduleBase.NoAuthenticationRequired

@NoAuthenticationRequired
class HomeController {
    def index = {
		redirect( controller: "assay", action: "list" ); 
	}
}
