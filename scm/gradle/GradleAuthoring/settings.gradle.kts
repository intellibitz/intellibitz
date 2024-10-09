/*
 * This file was generated by the Gradle 'init' task.
 *
 * The settings file is used to specify which projects to include in your build.
 * For more detailed information on multi-project builds, please refer to https://docs.gradle.org/8.10.2/userguide/multi_project_builds.html in the Gradle documentation.
 */

println("SETTINGS FILE: This is executed during the initialization phase")
//1. defines the location of plugins
pluginManagement {
    repositories {
        gradlePluginPortal()
        google()
    }
}
//2. applies settings plugins
plugins {
    // Apply the foojay-resolver plugin to allow automatic download of JDKs
    id("org.gradle.toolchains.foojay-resolver-convention") version "0.8.0"
}
//3. defines the root project name
rootProject.name = "GradleAuthoring"
//4. defines dependency resolution strategy
dependencyResolutionManagement{
    repositories {
        mavenCentral()
    }
}
//5. adds subprojects to the build
include("app")
include ("lib")
includeBuild("GradlePlugins/license")
