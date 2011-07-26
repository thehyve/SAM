package org.dbxp.sam

class SAMSample extends org.dbxp.moduleBase.Sample {
	String subjectName
	Long eventStartTime

	static constraints = {
		subjectName(nullable: true)
		eventStartTime(nullable: true)
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

		if( !jsonObject.eventObject || !jsonObject.eventObject.startTime  || jsonObject.eventObject.startTime == "null" ) {
			this.eventStartTime = null
		} else {
			if( jsonObject.eventObject.startTime.toString().isLong() ) {
				this.eventStartTime = Long.valueOf( jsonObject.eventObject.startTime.toString() );
			} else {
				this.eventStartTime = null;
			}
		}

	}
}
