import org.codehaus.groovy.grails.commons.ConfigurationHolder

/**
 * A script to automatically perform database changes
 *
 * Copied from GSCF DatabaseUpgrade on 15-09-2011 by Tjeerd van Dijk
 */
class DatabaseUpgrade {
	/**
	 * handle database upgrades
	 *
	 * @param dataSource
	 */
	public static void handleUpgrades(dataSource) {
		// get a sql instance
		groovy.sql.Sql sql = new groovy.sql.Sql(dataSource)

		// get configuration
		def config = ConfigurationHolder.config
		def db = config.dataSource.driverClassName

		// execute per-change check and upgrade code
		changeUniqueConstraints(sql, db)		// YouTrack Issue SAM-199

	}

    public static void changeUniqueConstraints(sql, db) {

        try {
            if(db == "org.postgresql.Driver") {
                // check if we need to perform this upgrade
                if (sql.firstRow("""SELECT count(*) as total
                                     FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
                                     WHERE TABLE_CATALOG='sam'
                                        AND CONSTRAINT_TYPE='UNIQUE'
                                        AND TABLE_NAME='feature'
                                        AND CONSTRAINT_NAME='feature_name_key';""").total > 0) {

                    sql.execute("ALTER TABLE feature DROP CONSTRAINT feature_name_key");
                    println "Constraint on Feature.name is dropped";
                }
                // check if we need to perform this upgrade
                if (sql.firstRow("""SELECT count(*) as total
                                     FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
                                     WHERE TABLE_CATALOG='sam'
                                        AND CONSTRAINT_TYPE='UNIQUE'
                                        AND TABLE_NAME='measurement'
                                        AND CONSTRAINT_NAME='measurement_featureid_sampleid';""").total == 0) {

                    sql.execute("ALTER TABLE measurement ADD CONSTRAINT measurement_featureid_sampleid UNIQUE (feature_id, sample_id)");
                    println "Constraint measurement_featureid_sampleid on (Measurement.feature_id, Measurement.sample_id) is added";
                }

            } else if(db == "com.mysql.jdbc.Driver") {
                // check if we need to perform this upgrade
                if (sql.firstRow('''SELECT count(*) as total
                                     FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
                                     WHERE TABLE_SCHEMA="sam"
                                        AND CONSTRAINT_TYPE="UNIQUE"
                                        AND TABLE_NAME="Feature"
                                        AND CONSTRAINT_NAME="name";''').total > 0) {

                    sql.execute("ALTER TABLE Feature DROP INDEX name");
                    println "Constraint on Feature.name is dropped";
                }
                // check if we need to perform this upgrade
                if (sql.firstRow('''SELECT count(*) as total
                                     FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
                                     WHERE TABLE_SCHEMA="sam"
                                        AND CONSTRAINT_TYPE="UNIQUE"
                                        AND TABLE_NAME="Measurement"
                                        AND CONSTRAINT_NAME="measurement_featureid_sampleid";''').total == 0) {

                    sql.execute("ALTER TABLE Measurement ADD CONSTRAINT measurement_featureid_sampleid UNIQUE (feature_id, sample_id)");
                    println "Constraint measurement_featureid_sampleid on (Measurement.feature_id, Measurement.sample_id) is added";
                }
            } else {
                println "ERROR: Unknown db in DatabaseUpgrade: "+db;
            }
        } catch (Exception e) {
            println "changeUniqueConstraints database upgrade failed: " + e.getMessage()
        }
	}
}