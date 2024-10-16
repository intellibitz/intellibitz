/*
 * This file was generated by the Gradle 'init' task.
 *
 * This generated file contains a sample Java application project to get you started.
 * For more details on building Java & JVM projects, please refer to https://docs.gradle.org/8.10.2/userguide/building_java_projects.html in the Gradle documentation.
 */

//1.	Apply plugins to the build.
plugins {
    // Apply the application plugin to add support for building a CLI application in Java.
    application
    id("org.plugin.license")
}

//2. Define the locations where dependencies can be found.
repositories {
    // Use Maven Central for resolving dependencies.
    mavenCentral()
}

//3. Add dependencies.
dependencies {
    // This dependency is used by the application.
    implementation(libs.guava)
    implementation(project(":lib")) // Add lib as an app dependency
    // Use JUnit Jupiter for testing.
    testImplementation(libs.junit.jupiter)
    testRuntimeOnly(libs.junit.platform.launcher)
//    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

// Apply a specific Java toolchain to ease working on different environments.
//4. Set properties.
java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}
application {
    // Define the main class for the application.
    mainClass = "org.app.App"
}

//5. Register and configure tasks.
tasks.named<Test>("test") {
    // Use JUnit Platform for unit tests.
    useJUnitPlatform()
}

tasks.register("task1"){
    println("REGISTER TASK1: This is executed during the configuration phase")
}

tasks.register("task2"){
    println("REGISTER TASK2: This is executed during the configuration phase")
}

tasks.named("task1"){
    println("NAMED TASK1: This is executed during the configuration phase")
    doFirst {
        println("NAMED TASK1 - doFirst: This is executed during the execution phase")
    }
    doLast {
        println("NAMED TASK1 - doLast: This is executed during the execution phase")
    }
}

tasks.named("task2"){
    println("NAMED TASK2: This is executed during the configuration phase")
    doFirst {
        println("NAMED TASK2 - doFirst: This is executed during the execution phase")
    }
    doLast {
        println("NAMED TASK2 - doLast: This is executed during the execution phase")
    }
}

println("BUILD SCRIPT: This is executed during the configuration phase")
