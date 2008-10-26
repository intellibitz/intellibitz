rootProject.name = "multiplatform"
include(":shared", ":server", ":app", ":browser", ":console")

pluginManagement {
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
    resolutionStrategy {
        eachPlugin {
            if (requested.id.namespace == "com.android" || requested.id.name == "kotlin-android-extensions") {
                useModule("com.android.tools.build:gradle:4.0.1")
            }
        }
    }
}

//include(":server")
//include(":app")
//include(":browser")
//include(":console")

