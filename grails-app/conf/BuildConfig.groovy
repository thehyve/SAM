grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
//grails.project.war.file = "target/${appName}-${appVersion}.war"
grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // uncomment to disable ehcache
        // excludes 'ehcache'
    }
    log "warn" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    repositories {
        grailsPlugins()
        grailsHome()
        grailsCentral()
        mavenRepo "http://nexus.nmcdsp.org/content/repositories/releases"
		mavenRepo "http://nexus.nmcdsp.org/content/repositories/snapshots"
		
        // uncomment the below to enable remote dependency resolution
        // from public Maven repositories
        //mavenLocal()
        //mavenCentral()
        //mavenRepo "http://snapshots.repository.codehaus.org"
        //mavenRepo "http://repository.codehaus.org"
        //mavenRepo "http://download.java.net/maven/2/"
        //mavenRepo "http://repository.jboss.com/maven2/"
    }
    dependencies {
        // specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes eg.

        // runtime 'mysql:mysql-connector-java:5.1.13'
    }
	plugins {

		compile(":hibernate:$grailsVersion")
		compile(":tomcat:$grailsVersion")
		compile ':jquery:1.7.1'
		compile ':jquery-datatables:1.7.5'
		compile ':jquery-ui:1.8.15'

		compile ':grom:0.2.3'
		compile ':ajaxflow:0.2.1'
		compile ':crypto:2.0'

		compile ':dbxp-module-base:0.4.16'
		compile ':matrix-importer:0.2.3.6'

		compile ':resources:1.1.6'

		compile(':gdt:0.2.1') {
			// disable plugin dependency transition because it's horribly broken
			// note: this assumes that ajaxflow, jquery and cryto stay included
			transitive = false
		}

		compile ':famfamfam:1.0.1'
		compile ':webflow:1.3.7'

	}
}

//grails.plugin.location.'dbxpModuleBase' = '../dbxpModuleBase'
//grails.plugin.location.'matrixImporter' = '../MatrixImporter'
//grails.plugin.location.'gdt' = '../gdt'

grails.server.port.http = "8182"  // The modern way of setting the server port
