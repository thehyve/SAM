class UrlMappings {

	static mappings = {
		"/$controller/$action?/$id?"{
			constraints {
				// apply constraints here
			}
		}

		"/"(controller:"assay")
		"/home"(controller:"assay")
		"500"(view:'/error')
	}
}
