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
	    grailsCentral()
	    grailsRepo "http://grails.org/plugins"
	    mavenCentral()

	    // grails 1.3.9 does not seem to properly inherit maven repo's from plugins
	    // so explicitely put ontocat in here. When upgraded to Grails 2.x this can
	    // probably be removed
	    mavenRepo "http://ontocat.sourceforge.net/maven/repo"

	    // other maven repo's
	    mavenRepo "http://nexus.dbnp.org/content/repositories/releases"
//	    mavenRepo "http://repository.springsource.com/maven/bundles/release"
//	    mavenRepo "http://repository.springsource.com/maven/bundles/external"
//	    mavenRepo "http://repository.springsource.com/maven/libraries/release"
//	    mavenRepo "http://repository.springsource.com/maven/libraries/external"
    }
    dependencies {
        // specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes eg.

        // runtime 'mysql:mysql-connector-java:5.1.13'
	// we seem to be needing XStream at compile time in some cases
	compile("com.thoughtworks.xstream:xstream:1.3.1")
    }
    plugins {

		compile(":hibernate:$grailsVersion")
		provided(":tomcat:$grailsVersion")
		compile ':jquery:1.8.3'
		compile ':jquery-datatables:1.7.5'
		compile ':jquery-ui:1.8.15'

        compile ":grom:latest.integration"
		compile ":ajaxflow:latest.integration"

		compile ':crypto:2.0'

		compile ':matrix-importer:0.2.3.6'

		compile ':resources:1.1.6'

		compile ':gdt:0.3.7.1'
			  	
		compile ':dbxp-module-base:0.5.0'

		compile ':famfamfam:1.0.1'
		compile ':webflow:2.0.0'
	}
}

//grails.plugin.location.'dbxpModuleBase' = '../dbxpModuleBase'
//grails.plugin.location.'matrixImporter' = '../MatrixImporter'
//grails.plugin.location.'gdt' = '../gdt'

grails.server.port.http = "8182"  // The modern way of setting the server port
