package org.dbxp.sam

class FuzzySearchService {

    static transactional = false
	
	/**
	 * Matches the patterns with the candidates, and returns the best candidates for all patterns, but returning
	 * the candidates only once
	 * 
	 * @param patterns		List with patterns to search for
	 * @param candidates	List with candidates to search in
	 * @param treshold		Treshold the matches have to be above
	 * @return				
	 */
	static def mostSimilarUnique( patterns, candidates, treshold ) {
		def matches = []
		
		// Find the best matching candidate for each pattern
		patterns.findAll { it }.each { pattern ->
			def topScore = 0
			def bestFit = null
			
			candidates.eachWithIndex { candidate, idx ->
				def score = stringSimilarity(pattern, candidate);
				if( !score.isNaN() && score >= treshold )
					matches << [ 'pattern': pattern, 'candidate': candidate, 'score': score, 'index': idx ];
			}
		}
		
		// Sort the list on descending score
		matches = matches.sort( { a, b -> b.score <=> a.score } as Comparator )
		
		// Loop through the scores and select the best matching for every candidate
		def results = patterns.collect { [ 'pattern': it, 'candidate': null, 'index': null ] }
		def selectedCandidates = [];
		def filledPatterns = [];
		
		matches.each { match ->
			if( !filledPatterns.contains( match.pattern ) && !selectedCandidates.contains( match.candidate ) ) {
				def foundMatch = results.find { result -> result.pattern == match.pattern };
                foundMatch?.candidate = match.candidate;
                foundMatch?.index = match.index;

				
				selectedCandidates << match.candidate;
				filledPatterns << match.pattern;
			}
		}
		
		return results
	}

	// classes for fuzzy string matching
	// <FUZZY MATCHING>
	static def similarity(l_seq, r_seq, degree=2) {
		def l_histo = countNgramFrequency(l_seq, degree)
		def r_histo = countNgramFrequency(r_seq, degree)

		dotProduct(l_histo, r_histo) /
				Math.sqrt(dotProduct(l_histo, l_histo) *
				dotProduct(r_histo, r_histo))
	}

	static def countNgramFrequency(sequence, degree) {
		def histo = [:]
		def items = sequence.size()

		for (int i = 0; i + degree <= items; i++)
		{
			def gram = sequence[i..<(i + degree)]
			histo[gram] = 1 + histo.get(gram, 0)
		}
		histo
	}

	static def dotProduct(l_histo, r_histo) {
		def sum = 0
		l_histo.each { key, value ->
			sum = sum + l_histo[key] * r_histo.get(key, 0)
		}
		sum
	}

	static def stringSimilarity (l_str, r_str, degree=2) {

		similarity(l_str.toString().toLowerCase().toCharArray(),
				r_str.toString().toLowerCase().toCharArray(),
				degree)
	}

	static def mostSimilar(pattern, candidates, threshold=0) {
		def topScore = 0
		def bestFit = null

		candidates.each { candidate ->
			def score = stringSimilarity(pattern, candidate)
			
			if (score > topScore) {
				topScore = score
				bestFit = candidate
			}
		}

		if (topScore < threshold)
			bestFit = null

		bestFit
	}
	
	static def mostSimilarWithIndex(pattern, candidates, threshold=0) {
		def topScore = 0
		def bestFit = null

		candidates.eachWithIndex { candidate, idx ->
			def score = stringSimilarity(pattern, candidate)
			
			if (score > topScore) {
				topScore = score
				bestFit = idx
			}
		}

		if (topScore < threshold)
			bestFit = null

		bestFit
	}

	// </FUZZY MATCHING>
}
