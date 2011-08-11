modules = {
	sam2 {
		dependsOn 'datatables'
		
		resource url: 'js/selectAddMore.js'
		resource url: 'js/removeWebFlowExecutionKey.js'
		resource url: 'css/sam.css'
		resource url: 'css/tooltip.css'
        resource url:'/images/subjectlayout.png', attrs:[alt:''], disposition:'inline'
        resource url:'/images/samplelayout.png', attrs:[alt:''], disposition:'inline'
    }

    tableEditor {
        resource url:[plugin: 'gdt', dir:'css', file: 'table-editor.css', disposition: 'head']
    }
	
	importer { 
		resource url: 'js/importer.js'
	}
}