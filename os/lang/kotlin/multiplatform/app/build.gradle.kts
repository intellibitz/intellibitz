plugins {
    id("com.android.application") apply(true)
    kotlin("android") apply true
    id("kotlin-android-extensions") apply(true)
}
group = "com.intellibitz"
version = "1.0-SNAPSHOT"

dependencies {
    implementation(project(":shared"))
    implementation("androidx.core:core-ktx:1.3.1")
    implementation("androidx.appcompat:appcompat:1.2.0")
    implementation("androidx.constraintlayout:constraintlayout:2.0.1")
}

android {
    compileSdkVersion(30)
    defaultConfig {
        applicationId = "intellibitz.app"
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