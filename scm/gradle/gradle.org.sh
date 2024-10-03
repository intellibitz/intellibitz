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

