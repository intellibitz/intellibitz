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

