#https://docs.gradle.org/current/userguide/userguide.html
#https://docs.gradle.org/current/userguide/quick_start.html

#Gradle supports Android, Java, Kotlin Multiplatform, Groovy, Scala, Javascript, and C/C++.
#The presence of the gradlew and gradlew.bat files in the root directory of a
# project is a clear indicator that Gradle is used.

$ gradle build #Gradle can be invoked in the command line

#The Wrapper is a script that invokes a declared version of Gradle and is the recommended way to execute a
# Gradle build. It is found in the project root directory as a gradlew or gradlew.bat file:
$ gradlew build     // Linux or OSX
$ gradlew.bat build  // Windows

#If you want to view or update the Gradle version of your project, use the
# command line. Do not edit the wrapper files manually:
$ ./gradlew --version
$ ./gradlew wrapper --gradle-version 8.10.2
$ ./gradlew --status

gradlew --help
gradlew -h

https://docs.gradle.org/current/userguide/getting_started_eng.html
#To execute a task called taskName on the root project, type:
$ gradle :taskName

#To pass an option to a task, prefix the option name with -- after the task name:
$ gradle taskName --exampleOption=exampleValue

#The primary purpose of the settings file is to add subprojects to your build.
<< 'settings.gradle.kts'
rootProject.name = "root-project"

include("sub-project-a")
include("sub-project-b")
include("sub-project-c")
settings.gradle.kts
#The settings file is a script. It is either a settings.gradle file written in Groovy or a
# settings.gradle.kts file in Kotlin.
#There is only one root project per build.

#In the build file, two types of dependencies can be added:
#The libraries and/or plugins on which Gradle and the build script depend.
#The libraries on which the project sources (i.e., source code) depend.
<< 'build.gradle.kts'
plugins {
    id("application")
}

application {
    mainClass = "com.example.Main"
}
build.gradle.kts
#Every Gradle build comprises at least one build script.

#Version catalogs provide a way to centralize your dependency declarations in a libs.versions.toml file.
#The version catalog typically contains four sections:
#[versions] to declare the version numbers that plugins and libraries will reference.
#[libraries] to define the libraries used in the build files.
#[bundles] to define a set of dependencies.
#[plugins] to define plugins.

#The file is located in the gradle directory so that it can be used by Gradle and IDEs automatically. The
# version catalog should be checked into source control: gradle/libs.versions.toml.
<< 'libs.versions.toml'
[versions]
androidGradlePlugin = "7.4.1"
mockito = "2.16.0"

[libraries]
googleMaterial = { group = "com.google.android.material", name = "material", version = "1.1.0-alpha05" }
mockitoCore = { module = "org.mockito:mockito-core", version.ref = "mockito" }

[plugins]
androidApplication = { id = "com.android.application", version.ref = "androidGradlePlugin" }
libs.versions.toml

#The following build.gradle.kts file adds a plugin and two dependencies to the project using the version catalog above:
<< 'build.gradle.kts'
plugins {
   alias(libs.plugins.androidApplication)
}

dependencies {
    // Dependency on a remote binary to compile and run the code
    implementation(libs.googleMaterial)

    // Dependency on a remote binary to compile and run the test code
    testImplementation(libs.mockitoCore)
}
build.gradle.kts

#You can view your dependency tree in the terminal using the ./gradlew :app:dependencies command:
$ ./gradlew :app:dependencies

#You run a Gradle build task using the gradle command or by invoking the Gradle Wrapper (./gradlew or gradlew.bat) in your project directory:
$ ./gradlew build

#All available tasks in your project come from Gradle plugins and build scripts.
#You can list all the available tasks in the project by running the following command in the terminal:
$ ./gradlew tasks
#You can also list the tasks only available in the app subproject by running
$ ./gradlew :app:tasks.
#You can obtain more information in the task listing using the --all option:
$ ./gradlew tasks --all

#The run task is executed with ./gradlew run:
$ ./gradlew run

#Many times, a task requires another task to run first.
$ ./gradlew build

#Plugins can be applied to a Gradle build script to add new tasks, configurations, or other build-related capabilities:
The Java Library Plugin - java-library
#Used to define and build Java libraries. It compiles Java source code with the compileJava task, generates Javadoc with the
# javadoc task, and packages the compiled classes into a JAR file with the jar task.

The Google Services Gradle Plugin - com.google.gms:google-services
#Enables Google APIs and Firebase services in your Android application with a configuration block called
# googleServices{} and a task called generateReleaseAssets.

The Gradle Bintray Plugin - com.jfrog.bintray
#Allows you to publish artifacts to Bintray by configuring the plugin using the bintray{} block.

#You apply plugins in the build script using a plugin id (a globally unique identifier / name) and a version:
<< 'build.gradle.kts'
plugins {
    id «plugin id» version «plugin version»
}
build.gradle.kts

#Core plugins are unique in that they provide short names, such as java for the core JavaPlugin, when applied in
# build scripts. They also do not require versions. To apply the java plugin to a project:
<< 'build.gradle.kts'
plugins {
    id("java")
}
build.gradle.kts

#Community plugins can be published at the Gradle Plugin Portal, where other Gradle users can easily discover and use them.
<< 'build.gradle.kts'
plugins {
    id("org.springframework.boot") version "3.1.5"
}
build.gradle.kts

#Incremental builds are always enabled, and the best way to see them in action is to turn on verbose mode.
# With verbose mode, each task state is labeled during a build:
$ ./gradlew compileJava --console=verbose

#When the build cache has been used to repopulate the local directory, the tasks are marked as FROM-CACHE:
$ ./gradlew compileJava --build-cache

#A build scan is a representation of metadata captured as you run your build.
#A Build Scan is a shareable and centralized record of a build and is available as a free service from Gradle.
#To enable build scans on a gradle command, add --scan to the command line option:
$ ./gradlew build --scan

https://docs.gradle.org/current/userguide/part1_gradle_init.html
$ gradle
$ gradle init --type java-application  --dsl kotlin

https://docs.gradle.org/current/userguide/part2_gradle_tasks.html#part2_begin
<< 'build.gradle.kts'
tasks.register<Copy>("copyTask") {
    from("source")
    into("target")
    include("*.war")
}

tasks.register("hello") {
    doLast {
        println("Hello!")
    }
}

tasks.register("greet") {
    doLast {
        println("How are you?")
    }
    dependsOn("hello")
}
build.gradle.kts

https://docs.gradle.org/current/userguide/part3_gradle_dep_man.html#part3_begin
<< 'build.gradle.kts'
repositories {
    // Use Maven Central for resolving dependencies.
    mavenCentral()
}

dependencies {
    // Use JUnit Jupiter for testing.
    testImplementation(libs.junit.jupiter)
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
    // This dependency is used by the application.
    implementation(libs.guava)
}

Some key concepts in Gradle dependency management include:

Repositories - The source of dependencies → mavenCentral()
Maven Central is a collection of jar files, plugins, and libraries provided by the Maven community and backed by
 Sonatype. It is the de-facto public artifact store for Java and is used by many build systems.
Dependencies - Dependencies declared via configuration types → libs.junit.jupiter and libs.guava

Gradle needs specific information to find a dependency. Let’s look at
 libs.guava → com.google.guava:guava:32.1.2-jre and
  libs.junit.jupiter → org.junit.jupiter:junit-jupiter-api:5.9.1; they are broken down as follows:

Description	                            com.google.guava:guava:32.1.2-jre,	org.junit.jupiter:junit-jupiter-api:5.9.1
Group / identifier of an organization   com.google.guava , org.junit.jupiter
Name  / dependency identifier           guava , junit-jupiter-api
Version / version # to import           32.1.2-jre , 5.9.1
build.gradle.kts

https://docs.gradle.org/current/userguide/part4_gradle_plugins.html#part4_begin
#The Maven Publish Plugin provides the ability to publish build artifacts to an Apache Maven repository. It can also
# publish to Maven local which is a repository located on your machine.
<< 'build.gradle.kts'
plugins {
    // Apply the application plugin to add support for building a CLI application in Java.
    application
    id("maven-publish")
}

publishing {
    publications {
        create<MavenPublication>("maven") {
            groupId = "com.gradle.tutorial"
            artifactId = "tutorial"
            version = "1.0"

            from(components["java"])
        }
    }
}
build.gradle.kts

#The publishToMavenLocal task builds the POM file and the artifacts to be published. It then installs them into the local Maven repository.
$ ./gradlew :app:publishToMavenLocal

#Plugins are used to extend build capability and customize Gradle. Using plugins is the primary mechanism for organizing build logic.
#Plugin authors can either keep their plugins private or distribute them to the public. As such, plugins are distributed three ways:

Core plugins - Gradle develops and maintains a set of Core Plugins.
Community plugins - Gradle’s community shares plugins via the Gradle Plugin Portal.
Custom plugins - Gradle enables user to create custom plugins using APIs.
Convention plugins are plugins used to share build logic between subprojects /modules .

#Users can wrap common logic in a convention plugin. For example, a code coverage plugin used as a convention plugin can
# survey code coverage for the entire project and not just a specific subproject.

Gradle highly recommends the use of Convention plugins.

https://docs.gradle.org/current/userguide/part5_gradle_inc_builds.html#part5_begin
$ ./gradlew :app:clean :app:build
$ ./gradlew :app:build

#There are four labels that developers can use to view task outcomes when verbose mode is turned on:
#OutcomeLabel	Description
UP-TO-DATE    Task that has been already executed and hasn’t changed ~incremental build feature
SKIPPED       Task was explicitly prevented from running
FROM-CACHE    Task output has been copied to local directory from previous builds in the build cache ~caching feature
NO-SOURCE     Task was not executed because its required inputs were not available
#If there is no label, the task was newly executed by Gradle ~locally.

https://docs.gradle.org/current/userguide/part6_gradle_caching.html#part6_begin
https://docs.gradle.org/current/userguide/gradle_directories.html
#Add org.gradle.caching=true to the gradle.properties file:
<< 'gradle.properties'
org.gradle.console=verbose
org.gradle.caching=true
gradle.properties

$ ./gradlew :app:clean :app:build
$ ./gradlew :app:build

#Gradle lets us know the outcome of each task in the console output:
FROM-CACHE - tasks have been fetched from the local build cache.
UP-TO-DATE - tasks that used incremental build and were not re-run.

#To summarize:
First, we used the build task to populate our local cache with task inputs and outputs, we can imagine this was done a week ago.
Then, we used the clean task to mimic switching branches, overriding previous outputs.
Finally, we used the build task, unlike incremental builds, the previous outputs were stored in the local cache and could be reused.

Gradle is efficient, especially with the local build cache turned on. Gradle will look at the cache directory on your
 machine to check for output files that may already exist. If they do, instead of running that task, it will copy its
  ~output results into your project build directory.
The outcome label FROM-CACHE lets the user know that Gradle has fetched the task results from the local build cache.

https://docs.gradle.org/current/userguide/part7_gradle_refs.html#part7_begin
#http://gradle.org/docs/current/javadoc/
https://docs.gradle.org/current/dsl/index.html
https://docs.gradle.org/current/kotlin-dsl/index.html
https://docs.gradle.org/current/userguide/plugin_reference.html#plugin_reference
#https://plugins.gradle.org/
#https://gradle.org/releases/
http://gradle.org/docs/current/release-notes
#https://discuss.gradle.org/
#https://gradle-community.slack.com/
#https://gradle.org/courses/

https://docs.gradle.org/current/userguide/command_line_interface.html#command_line_interface

https://docs.gradle.org/current/userguide/getting_started_dev.html
