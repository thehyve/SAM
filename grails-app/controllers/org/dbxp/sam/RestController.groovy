package org.dbxp.sam

import grails.converters.JSON
import dbnp.studycapturing.*

class RestController {

	/****************************************************************/
	/* REST resources for providing basic data to the GSCF          */
	/****************************************************************/

	/**
	 * Return a list of simple assay measurements matching the querying text.
	 *
	 * @param assayToken
	 * @return list of feature names for assay.
	 *
	 * Example REST call:
	 * http://localhost:8184/metagenomics/rest/getMeasurements/query?assayToken=16S-5162
	 *
	 * Resulting JSON object:
	 *
	 * [ "# sequences", "average quality" ]
	 *
	 */
	def getMeasurements = {
		def assayToken = params.assayToken;
		def assay = getAssay( assayToken );
		if( !assay ) {
			response.sendError(404)
			return false
		}
		
		// Return all features for the given assay
		def features = Feature.executeQuery( "SELECT DISTINCT f FROM Feature f, Measurement m, SAMSample s WHERE m.feature = f AND m.sample = s AND s.parentAssay = :assay", [ "assay": assay ] )
		
		render features.collect { it.name } as JSON
	}

	/**
	 * Return measurement metadata for measurement
	 *
	 * @param assayToken
	 * @param measurementTokens. List of measurements for which the metadata is returned.
	 *                           If this is not given, then return metadata for all
	 *                           measurements belonging to the specified assay.
	 * @return list of measurements
	 *
	 * Example REST call:
	 * http://localhost:8184/metagenomics/rest/getMeasurementMetadata/query?assayToken=16S-5162
	 *      &measurementToken=# sequences
	 *		&measurementToken=average quality
	 *
	 * Example resulting JSON object:
	 *
	 * [ {"name":"# sequences","type":"raw"},
	 *   {"name":"average quality", "unit":"Phred"} ]
	 */
	def getMeasurementMetaData = {
		def assayToken = params.assayToken;
		def assay = getAssay( assayToken );
		if( !assay ) {
			response.sendError(404)
			return false
		}
		
		def measurementTokens = params.list( 'measurementToken' );
		def features
		
		if( measurementTokens ) {
			// Return all requested features for the given assay
			features = Feature.executeQuery( "SELECT DISTINCT f FROM Feature f, Measurement m, SAMSample s WHERE m.sample = s AND m.feature = f AND s.parentAssay = :assay AND f.name IN (:measurementTokens)", [ "assay": assay, "measurementTokens": measurementTokens ] )
		} else {
			// If no measurement tokens are given, return values for all features
			features = Feature.executeQuery( "SELECT DISTINCT f FROM Feature f, Measurement m, SAMSample s WHERE m.sample = s AND m.feature = f AND s.parentAssay = :assay", [ "assay": assay ] )
		}
		
		render features.collect { feature -> 
			def obj = [:];
			feature.giveFields().each { field ->
				obj[ field.name ] = feature.getFieldValue( field.name );
			}
			return obj;
		} as JSON
	}

	/**
	 * Return list of measurement data.
	 *
	 * @param assayToken
	 * @param measurementToken. Restrict the returned data to the measurementTokens specified here.
	 * 						If this argument is not given, all samples for the measurementTokens are returned.
	 * 						Multiple occurrences of this argument are possible.
	 * @param sampleToken. Restrict the returned data to the samples specified here.
	 * 						If this argument is not given, all samples for the measurementTokens are returned.
	 * 						Multiple occurrences of this argument are possible.
	 * @param boolean verbose. If this argument is not present or it's value is true, then return
	 *                    getAssay  the date in a redundant format that is easier to process.
	 *						By default, return a more compact JSON object as follows.
	 *
	 * 						The list contains three elements:
	 *
	 *						(1) a list of sampleTokens,
	 *						(2) a list of measurementTokens,
	 * 						(3) a list of values.
	 *
	 * 						The list of values is a matrix represented as a list. Each row of the matrix
	 * 						contains the values of a measurementToken (in the order given in the measurement
	 * 						token list, (2)). Each column of the matrix contains the values for the sampleTokens
	 * 						(in the order given in the list of sampleTokens, (1)).
	 * 						(cf. example below.)
	 *
	 *
	 * @return  table (as hash) with values for given samples and measurements
	 *
	 *
	 * List of examples.
	 *
	 *
	 * Example REST call:
	 * http://localhost:8184/metagenomics/rest/getMeasurementData/doit?assayToken=PPSH-Glu-A
	 *    &measurementToken=total carbon dioxide (tCO)
	 *    &sampleToken=5_A
	 *    &sampleToken=1_A
	 *    &verbose=true
	 *
	 * Resulting JSON object:
	 * [ {"sampleToken":"1_A","measurementToken":"total carbon dioxide (tCO)","value":28},
	 *   {"sampleToken":"5_A","measurementToken":"total carbon dioxide (tCO)","value":29} ]
	 *
	 *
	 *
	 * Example REST call without sampleToken, without measurementToken,
	 *    and with verbose representation:
	 * http://localhost:8184/metagenomics/rest/getMeasurementData/dossit?assayToken=PPSH-Glu-A
	 *    &verbose=true
	 *
	 * Resulting JSON object:
	 * [ {"sampleToken":"1_A","measurementToken":"sodium (Na+)","value":139},
	 *	 {"sampleToken":"1_A","measurementToken":"potassium (K+)","value":4.5},
	 *	 {"sampleToken":"1_A","measurementToken":"total carbon dioxide (tCO)","value":26},
	 *	 {"sampleToken":"2_A","measurementToken":"sodium (Na+)","value":136},
	 *	 {"sampleToken":"2_A","measurementToken":"potassium (K+)","value":4.3},
	 *	 {"sampleToken":"2_A","measurementToken":"total carbon dioxide (tCO)","value":28},
	 *	 {"sampleToken":"3_A","measurementToken":"sodium (Na+)","value":139},
	 *	 {"sampleToken":"3_A","measurementToken":"potassium (K+)","value":4.6},
	 *	 {"sampleToken":"3_A","measurementToken":"total carbon dioxide (tCO)","value":27},
	 *	 {"sampleToken":"4_A","measurementToken":"sodium (Na+)","value":137},
	 *	 {"sampleToken":"4_A","measurementToken":"potassium (K+)","value":4.6},
	 *	 {"sampleToken":"4_A","measurementToken":"total carbon dioxide (tCO)","value":26},
	 *	 {"sampleToken":"5_A","measurementToken":"sodium (Na+)","value":133},
	 *	 {"sampleToken":"5_A","measurementToken":"potassium (K+)","value":4.5},
	 *	 {"sampleToken":"5_A","measurementToken":"total carbon dioxide (tCO)","value":29} ]
	 *
	 *
	 *
	 * Example REST call with default (non-verbose) view and without sampleToken:
	 *
	 * Resulting JSON object:
	 * http://localhost:8184/metagenomics/rest/getMeasurementData/query?
	 * 	assayToken=PPSH-Glu-A&
	 * 	measurementToken=sodium (Na+)&
	 * 	measurementToken=potassium (K+)&
	 *	measurementToken=total carbon dioxide (tCO)
	 *
	 * Resulting JSON object:
	 * [ ["1_A","2_A","3_A","4_A","5_A"],
	 *   ["sodium (Na+)","potassium (K+)","total carbon dioxide (tCO)"],
	 *   [139,136,139,137,133,4.5,4.3,4.6,4.6,4.5,26,28,27,26,29] ]
	 *
	 * Explanation:
	 * The JSON object returned by default (i.e., unless verbose is set) is an array of three arrays.
	 * The first nested array gives the sampleTokens for which data was retrieved.
	 * The second nested array gives the measurementToken for which data was retrieved.
	 * The thrid nested array gives the data for sampleTokens and measurementTokens.
	 *
	 *
	 * In the example, the matrix represents the values of the above Example and
	 * looks like this:
	 *
	 * 			1_A		2_A		3_A		4_A		5_A
	 *
	 * Na+		139		136		139		137		133
	 *
	 * K+ 		4.5		4.3		4.6		4.6		4.5
	 *
	 * tCO		26		28		27		26		29
	 *
	 */
	def getMeasurementData = {
		def verbose = false
		
		if(params.verbose && (params.verbose=='true'||params.verbose==true) ) {
			verbose=true
		}
		
		def assayToken = params.assayToken;
		def assay = getAssay( assayToken );
		if( !assay ) {
			response.sendError(404)
			return false
		}
		
		def measurementTokens = params.list( 'measurementToken' );
		def sampleTokens = params.list( 'sampleToken' );
		
		def features
		def samples
		def results
		
		if( measurementTokens ) {
			// Return all requested features for the given assay
			features = Feature.executeQuery( "SELECT DISTINCT f FROM Feature f, Measurement m, SAMSample s WHERE m.sample = s AND m.feature = f AND s.parentAssay = :assay AND f.name IN (:measurementTokens)", [ "assay": assay, "measurementTokens": measurementTokens ] )
			log.debug("Found ${features.size()} features matching the ${measurementTokens.size()} measurement tokens")		
		} else {
			// If no measurement tokens are given, return values for all features
			features = Feature.executeQuery( "SELECT DISTINCT f FROM Feature f, Measurement m, SAMSample s  WHERE m.sample = s AND m.feature = f AND s.parentAssay = :assay", [ "assay": assay ] )
			log.debug("Using all ${features.size()} features")
		}
		
		if( sampleTokens ) {
			// Return all requested samples
			samples = SAMSample.executeQuery( "SELECT s FROM SAMSample s WHERE s.parentAssay = :assay AND s.parentSample.UUID IN (:sampleTokens)", [ "assay": assay, "sampleTokens": sampleTokens ] )
			log.debug("Found ${samples.size()} samples matching the ${sampleTokens.size()} sample tokens")
			/*log.debug("i got this: ${sampleTokens}")
			def alles = Sample.executeQuery( "SELECT s.sampleToken FROM Sample s WHERE s.assay = :assay", [ "assay": assay] )
			log.debug("alles is ${alles}")
			alles.each {
					log.debug(it.dump())
			}*/
		} else {
			// If no sampleTokens are given, return all	
			samples = assay.samples;
			log.debug("Using all ${samples.size()} samples")
		}
		
		// If no samples or features are selected, return an empty list
		if( !samples || !features ) {
			results = []
			log.debug("No samples or no features, returning empty result")
		}
		else {
		
			// Retrieve all measurements from the database
            def measurements = Measurement.executeQuery("SELECT m, m.feature, m.sample FROM Measurement m WHERE m.feature IN (:features) AND m.sample IN (SELECT s FROM SAMSample s WHERE s.parentAssay = :assay)", ["assay": assay, "features": features])

			// Convert the measurements into the desired format
			results = measurements.collect { [
				"sampleToken": 		it[ 2 ].parentSample.UUID,
				"measurementName": it[ 1 ].name,
				"value":			it[ 0 ].value
			] }
			
			if(!verbose) {
				results = compactTable( results )
			}
		}		
		render results as JSON
	}
	
	/**
	 * Retrieves an assay from the database, based on a given assay token.
	 * @param assayToken	Assaytoken for the assay to retrieve
	 * @return				Assay or null if assayToken doesn't exist
	 */
	private def getAssay( def assayToken ) {
		if( !assayToken || assayToken == null ) {
			return null
		}
		def list = []
		def assay = Assay.findWhere(UUID: assayToken )

		return assay;
	}


    /* helper function for getMeasurementData
     *
     * Return compact JSON object for data. The format of the returned array is as follows.
     *
     * The list contains three elements:
     *
     * (1) a list of sampleTokens,
     * (2) a list of measurementTokens,
     * (3) a list of values.
     *
     * The list of values is a matrix represented as a list. Each row of the matrix
     * contains the values of a measurementToken (in the order given in the measurement
     * token list, (2)). Each column of the matrix contains the values for the sampleTokens
     * (in the order given in the list of sampleTokens, (1)).
     */
    private def compactTable( results ) {
        def sampleTokens = results.collect( { it['sampleToken'] } ).unique()
        def measurementTokens = results.collect( { it['measurementToken'] } ).unique()

        def data = []
        measurementTokens.each{ m ->
            sampleTokens.each{ s ->
                def item = results.find{ it['sampleToken']==s && it['measurementToken']==m }
                data.push item ? item['value'] : null
            }
        }

        return [ sampleTokens, measurementTokens, data ]
    }
}
