# gradle-grails-bom

This publishes a Maven `pom.xml` containing the same dependencies as when
using Grails 2.x `grails create-app` and `grails create-plugin`.  This is
used as a standard Grails "BOM" when using the
[io.spring.gradle:dependency-management-plugin](https://github.com/spring-gradle-plugins/dependency-management-plugin)
for Gradle.

The
[org.grails:grails-gradle-plugin](https://github.com/grails/grails-gradle-plugin)
can then be used to switch to using a Gradle build system for Grails 2.x. 
Use version 2.2.0.RC1 or later (in the 2.x line) of grails-gradle-plugin for
Grails 2.5.4.

This can also help ease the transition from Grails 2 to Grails 3 by helping
you to convert your Grails 2 applications and plugins to Gradle before
you're ready to upgrade to Grails 3.  Then, when it comes time to upgrade to
Grails 3 later, you will have already converted to Gradle, making it easier
to upgrade to Grails 3.

## License

[BSD two-clause](LICENSE.txt)

## Versioning

The version of the plugin matches the Grails version for which the BOM has
been generated.

## Using

To install the BOM to your local Maven repository:
`gradle publishToMavenLocal`

Then to use the BOM in a Gradle/Grails project, add something like this to
your `build.gradle`:
```
buildscript {
    repositories {
        mavenLocal()
        jcenter()
        mavenCentral()
    }
    dependencies {
        classpath "io.spring.gradle:dependency-management-plugin:0.5.6.RELEASE"
        classpath "org.grails:grails-gradle-plugin:2.2.0.RC1"
    }
}

apply plugin: 'grails'
apply plugin: "io.spring.dependency-management"

grails {
    grailsVersion = '2.5.4'
    groovyVersion = '2.4.4'
}

repositories {
    mavenLocal()
    jcenter()
    grails.central()
    mavenCentral()
}

dependencyManagement {
    imports {
        mavenBom "edu.berkeley.calnet:gradle-grails-bom:2.5.4"
    }
}

dependencies {
    /**
     * Specify the Grails dependencies you need.
     * These depedencies have their versions set in the BOM.
     */
    provided 'javax.servlet:javax.servlet-api'

    runtime('org.grails.plugins:hibernate4') {
        exclude module: 'xml-apis'
    }

    test 'junit:junit'
    test 'org.spockframework:spock-core'
}
```

## Extra Notes

The [bin/generateDependencyMgmtBlock.sh](bin/generateDependencyMgmtBlock.sh)
script is used to generate the Grails dependencies listed in
[build.gradle](build.gradle) for the BOM.
