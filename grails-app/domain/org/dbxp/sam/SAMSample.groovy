package org.dbxp.sam
import dbnp.studycapturing.Sample
import dbnp.studycapturing.Assay

class SAMSample extends Sample {
	String subjectName
	Long eventStartTime

	static hasMany = [measurements: Measurement]
	
	static constraints = {
		subjectName(nullable: true)
		eventStartTime(nullable: true)
	}
	
	static mapping = {
		measurements cascade: "all-delete-orphan"
	}
	
	/**
	 * Sets the properties of this object, based on the JSON object given by GSCF
	 * @param jsonObject	Object with sample data from GSCF
	 */
	@Override
	public void setPropertiesFromGscfJson( jsonObject ) {
		super.setPropertiesFromGscfJson( jsonObject );

		if( !jsonObject.subjectObject || !jsonObject.subjectObject.name  || jsonObject.subjectObject.name == "null" ) {
			this.subjectName = null
		} else {
			this.subjectName = jsonObject.subjectObject.name.toString();
		}

		if( jsonObject.eventObject == null || jsonObject.eventObject.startTime == null || jsonObject.eventObject.startTime == "null" ) {
			this.eventStartTime = null
		} else {
			if( jsonObject.eventObject.startTime.toString().isLong() ) {
				this.eventStartTime = Long.valueOf( jsonObject.eventObject.startTime.toString() );
			} else {
				this.eventStartTime = null;
			}
		}

	}
	
	/**
	* Return all samples this user may read
	* @param user
	* @return
	*/
   public static giveReadableSamples( user ) {
	   def assays = Assay.giveReadableAssays( user );
	   if( !assays )
		   return []
		   
	   return Sample.findAll( "FROM SAMSample s WHERE s.assay IN (:assays)", [ "assays": assays ] )
   }
   
   
   /**
   * Return all samples this user may write
   * @param user
   * @return
   */
  public static giveWritableSamples( user ) {
	  def assays = Assay.giveWritableAssays( user );
	  if( !assays )
		  return []
		  
	  return Sample.findAll( "FROM SAMSample s WHERE s.assay IN (:assays)", [ "assays": assays ] )
  }
}
