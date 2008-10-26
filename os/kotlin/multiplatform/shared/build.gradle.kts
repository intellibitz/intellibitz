plugins {
    kotlin("multiplatform") apply true
    id("com.android.library") apply(true)
    id("kotlin-android-extensions") apply(true)
}
group = "com.intellibitz"
version = "1.0-SNAPSHOT"

kotlin {
    android()
    iosX64("ios") {
        binaries {
            framework {
                baseName = "shared"
            }
        }
    }
    sourceSets {
        val commonMain by getting
        val commonTest by getting {
            dependencies {
                implementation(kotlin("test-common"))
                implementation(kotlin("test-annotations-common"))
            }
        }
        val androidMain by getting {
            dependencies {
                implementation("androidx.core:core-ktx:1.3.1")
            }
        }
        val androidTest by getting
    }
}
android {
    compileSdkVersion(30)
    defaultConfig {
        minSdkVersion(24)
        targetSdkVersion(30)
        versionCode = 1
        versionName = "1.0"
    }
    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
        }
    }
}
