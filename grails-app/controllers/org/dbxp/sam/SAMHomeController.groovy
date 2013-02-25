package org.dbxp.sam

class SAMHomeController {
    def index = {

        [platform: params?.platform]
		 
	}


    def transcriptomics = {

        redirect(action: "index", params: [platform: "Transcriptomics"])
    }

    def metabolomics = {

        redirect(action: "index", params: [platform: "Metabolomics"])
    }

    def proteomics = {

        redirect(action: "index", params: [platform: "Proteomics"])
    }

    def questionnaire = {

        redirect(action: "index", params: [platform: "Questionnaire"])
    }


}
