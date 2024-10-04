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
#To enable build scans on a gradle command, add --scan to the command line option:
$ ./gradlew build --scan

