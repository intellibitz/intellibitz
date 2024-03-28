buildscript {
// Top-level build file where you can add configuration options common to all sub-projects/modules.
    repositories {
        google()
        jcenter()
        gradlePluginPortal()
        maven {
            url = uri("https://dl.bintray.com/kotlin/kotlin-eap")
        }
    }
    dependencies {
//        classpath 'com.android.tools.build:gradle:4.0.1'

        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle files
        classpath("com.android.tools.build:gradle:4.0.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.4.0")
        classpath ("androidx.navigation:navigation-safe-args-gradle-plugin:2.3.0")
        classpath("com.google.gms:google-services:4.3.3")
    }
}

group = "intellibitz"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
    maven {
        url = uri("https://dl.bintray.com/kotlin/kotlin-eap")
    }
}


tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}

/*
allprojects {
    repositories {
        jcenter()
        maven {
            url 'https://maven.google.com'
        }
        google()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
*/
