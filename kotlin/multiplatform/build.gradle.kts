/*
https://docs.gradle.org/current/userguide/kotlin_dsl.html
Applying plugins
You can declare your plugins within the subprojects to which they apply, but we recommend that you also declare them
within the root project build script. This makes it easier to keep plugin versions consistent across projects within
 a build. The approach also improves the performance of the build.
 */
plugins {
    kotlin("multiplatform") version "1.4.0" apply false
    kotlin("android") version "1.4.0" apply false
    kotlin("jvm") version "1.4.0" apply false
    kotlin("js") version "1.4.0" apply false
    kotlin("plugin.serialization") version "1.4.0" apply false
    id("org.gretty") version ("3.0.3") apply (false)
//    id("org.akhikhl.gretty") version ("2.0.0") apply (false)
//    id("com.google.cloud.tools.appengine") apply (false)
}
buildscript{
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.4.0")
        classpath("com.android.tools.build:gradle:4.0.1")
        classpath("com.google.cloud.tools:appengine-gradle-plugin:2.2.0")
        classpath("org.gretty:gretty:3.0.3")
        classpath("org.jetbrains.kotlin:kotlin-serialization:1.4.0")
//        classpath("gradle.plugin.org.gretty:gretty:3.0.3")
//        classpath("org.akhikhl.gretty:gretty:2.0.0")
    }
}

group = "com.intellibitz"
version = "1.0-SNAPSHOT"

repositories {
    maven {
        url = uri("https://dl.bintray.com/kotlin/kotlin-eap")
    }
    maven {
        url = uri("https://oss.jfrog.org/artifactory/oss-snapshot-local/")
    }
    mavenCentral()
    jcenter()
    google()
    gradlePluginPortal()
}

allprojects{
}
