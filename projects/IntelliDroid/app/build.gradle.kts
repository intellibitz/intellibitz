import java.util.*

/*
import org.gradle.kotlin.dsl.apply
import org.gradle.kotlin.dsl.dependencies
import org.gradle.kotlin.dsl.kotlin
import org.gradle.kotlin.dsl.*
import org.jetbrains.kotlin.config.KotlinCompilerVersion
*/

plugins {
    id("com.android.application")
    kotlin("android")
    kotlin("kapt")
    id("kotlin-android-extensions")
    id("androidx.navigation.safeargs.kotlin")
    id("com.google.gms.google-services")
}

group = "intellibitz"
version = "1.0-SNAPSHOT"

repositories {
    gradlePluginPortal()
    google()
    jcenter()
    mavenCentral()
    maven {
        url = uri("https://dl.bintray.com/kotlin/kotlin-eap")
    }
}

android {
    /**
     * compileSdkVersion specifies the Android API level Gradle should use to
     * compile your app. This means your app can use the API features included in
     * this API level and lower.
     */
    compileSdkVersion(30)
    /**
     * buildToolsVersion specifies the version of the SDK build tools, command-line
     * utilities, and compiler that Gradle should use to build your app. You need to
     * download the build tools using the SDK Manager.
     *
     * This property is optional because the plugin uses a recommended version of
     * the build tools by default.
     */
    buildToolsVersion("30.0.2")
    buildFeatures {
//The databinding library is bundled with the Android Gradle plugin.
// You do not need to declare a dependency on the library, but you must enable it.
//    implementation("androidx.databinding:databinding:3.6.0-alpha10")
        dataBinding = true
    }

    /**
     * The defaultConfig block encapsulates default settings and entries for all
     * build variants, and can override some attributes in main/AndroidManifest.xml
     * dynamically from the build system. You can configure product flavors to override
     * these values for different versions of your app.
     */
    defaultConfig {
        /**
         * applicationId uniquely identifies the package for publishing.
         * However, your source code should still reference the package name
         * defined by the package attribute in the main/AndroidManifest.xml file.
         */
        applicationId = "intellibitz.intellidroid"
        minSdkVersion(24)
        targetSdkVersion(30)
        versionCode = 1
// Defines a user-friendly version name for your app.
        versionName = "1.0"
        vectorDrawables.useSupportLibrary = true
//https://developer.android.com/studio/build/multidex
//If your minSdkVersion is set to 21 or higher, multidex is enabled by default and you do not need the multidex support library.
        // Enabling multidex support. (only for sdk 20 or lower)
        multiDexEnabled = true
//Don't use MultiDexTestRunner, which is deprecated; use AndroidJUnitRunner instead.
////When you write instrumentation tests for multidex apps, no additional configuration is required
//// if you use a MonitoringInstrumentation (or an AndroidJUnitRunner) instrumentation.
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
//        testInstrumentationRunner = "intellibitz.intellidroid.test.MultiDexTestRunner"
        externalNativeBuild {
            cmake {
                cppFlags("-frtti -fexceptions")
            }
        }
    }

    // The flavorSelection property uses the following format:
    // flavorSelection "dimension_name", "flavor_name"

    // Chooses the "color" flavor from libraries that specify a "shape"
    // dimension.
//        flavorSelection "color", "shape"
    // Specifies one flavor dimension.
    flavorDimensions("color")
    /**
     * The productFlavors block is where you can configure multiple product flavors.
     * This allows you to create different versions of your app that can
     * override the defaultConfig block with their own settings. Product flavors
     * are optional, and the build system does not create them by default.
     *
     * This example creates a free and paid product flavor. Each product flavor
     * then specifies its own application ID, so that they can exist on the Google
     * Play Store, or an Android device, simultaneously.
     *
     * If you declare product flavors, you must also declare flavor dimensions
     * and assign each flavor to a flavor dimension.
     */
    productFlavors {
        // Define separate dev and prod product flavors.
        create("dev") {
            // Assigns this product flavor to the "color" flavor dimension.
            // This step is optional if you are using only one dimension.
            dimension = "color"
            // dev utilizes minSDKVersion = 21 to allow the Android gradle plugin
            // to pre-dex each module and produce an APK that can be tested on
            // Android Lollipop without time consuming dex merging processes.
            minSdkVersion(24)
//            minSdkVersion 11
            applicationId = "intellibitz.intellidroid.dev"
            versionCode = 1
            versionName = "1.0-dev"
        }
        create("qa") {
            // Assigns this product flavor to the "color" flavor dimension.
            // This step is optional if you are using only one dimension.
            dimension = "color"
//        targets 4.4 kitkat
            minSdkVersion(24)
            applicationId = "intellibitz.intellidroid.qa"
            versionCode = 1
            versionName = "1.0-qa"
        }
        create("uat") {
            // Assigns this product flavor to the "color" flavor dimension.
            // This step is optional if you are using only one dimension.
            dimension = "color"
            minSdkVersion(24)
            applicationId = "intellibitz.intellidroid.uat"
            versionCode = 1
            versionName = "1.0-uat"
        }
        create("prod") {
            // Assigns this product flavor to the "color" flavor dimension.
            // This step is optional if you are using only one dimension.
            dimension = "color"
            // The actual minSdkVersion for the application.
//        targets 3.0 honeycomb 97.3% of devices
//        targets api15 - 4.0.3 icecream 97.3% of devices
            minSdkVersion(24)
        }
/*
2.2	Froyo	8	0.1%
2.3.3 -
2.3.7	Gingerbread	10	1.7%

4.0.3 -
4.0.4	Ice Cream Sandwich	15	1.6%

4.1.x	Jelly Bean	16	6.0%
4.2.x	17	8.3%
4.3	18	2.4%

4.4	KitKat	19	29.2%

5.0	Lollipop	21	14.1%
5.1	22	21.4%

6.0	Marshmallow	23	15.2%

Data collected during a 7-day period ending on August 1, 2016.
 */
//        testInstrumentationRunner "android.support.test.runner.AndroidJUnitRunner"
//        testInstrumentationRunner "com.android.test.runner.MultiDexTestRunner"
//        testInstrumentationRunner "com.google.android.apps.common.testing.testrunner.GoogleInstrumentationTestRunner"
//        testInstrumentationRunner "android.test.InstrumentationTestRunner"
//        testInstrumentationRunner "android.support.test.runner.AndroidJUnitRunner"
//        restricts resource configuration to locales
//        resConfigs "en", "in"
/*
        jackOptions {
            enabled false
        }
*/
    }


    val props = Properties()
    props.load(project.file("${projectDir}/keystore.properties").inputStream())
    signingConfigs {
        create("release") {
            storeFile = file("${projectDir}/" + props.getProperty("storeFile"))
            storePassword = props.getProperty("storePassword")
            keyAlias = props.getProperty("keyAlias")
            keyPassword = props.getProperty("keyPassword")
        }
    }

    /**
     * The buildTypes block is where you can configure multiple build types.
     * By default, the build system defines two build types: debug and release. The
     * debug build type is not explicitly shown in the default build configuration,
     * but it includes debugging tools and is signed with the debug key. The release
     * build type applies Proguard settings and is not signed by default.
     */
    buildTypes {
        getByName("debug") {
            applicationIdSuffix = ".debug"
        }

        getByName("release") {
//            linke minfied, be careful about what gets removed
//            shrinkResources true
/*
            < ? xml version = "1.0" encoding = "utf-8" ? >
            < resources xmlns: tools = "http://schemas.android.com/tools"
            tools:keep = "@layout/l_used*_c,@layout/l_used_a,@layout/l_used_b*"/>
<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:shrinkMode="safe"
    tools:discard="@layout/unused2"/>
*/
//            the below minifyEnabled is for progaurd.. turn it on for production
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
/*
    externalNativeBuild {
        cmake {
            path "CMakeLists.txt"
        }
    }
*/

        /**
         * The "initWith" property allows you to copy configurations from other build types,
         * so you don"t have to configure one from the beginning. You can then configure
         * just the settings you want to change. The following line initializes
         * "jnidebug" using the debug build type, and changes only the
         * applicationIdSuffix and versionNameSuffix settings.
         */

        create("jnidebug") {

            // This copies the debuggable attribute and debug signing configurations.
            initWith(getByName("debug"))

            applicationIdSuffix = ".jnidebug"
            isJniDebuggable = true
        }
    }


    testOptions {
        unitTests {
            unitTests.isReturnDefaultValues = true
        }
    }
    compileOptions {
        targetCompatibility = JavaVersion.VERSION_1_8
        sourceCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        // work-runtime-ktx 2.1.0 and above now requires Java 8
        jvmTarget = "1.8"

        // Enable Coroutines and Flow APIs
        freeCompilerArgs =
            freeCompilerArgs + "-Xopt-in=kotlinx.coroutines.ExperimentalCoroutinesApi"
        freeCompilerArgs = freeCompilerArgs + "-Xopt-in=kotlinx.coroutines.FlowPreview"
    }
    lintOptions {
        tasks.findByName("lint")?.enabled = false
        isQuiet = true
        isAbortOnError = false
    }

    useLibrary("org.apache.http.legacy")
//    useLibrary("android.test")
    useLibrary("android.test.runner")
    useLibrary ("android.test.base")
    useLibrary("android.test.mock")

/*
    implementationOptions {
        incremental=true
    }
*/
/*
    sourceSets {
        main {
            manifest.srcFile "src/main/AndroidManifest.xml"
            java.srcDirs = ["src/main/java"]
            resources.srcDirs = ["src/main/res"]
            aidl.srcDirs = ["src/main/java"]
            renderscript.srcDirs = ["src/main/java"]
            res.srcDirs = ["src/main/res"]
            assets.srcDirs = ["assets"]
            jni.srcDirs = []
            jniLibs.srcDirs = ["libs"]
        }
        debug.setRoot("build-types/debug")
        release.setRoot("build-types/release")
    }
*/
}

dependencies {
//    implementation(project(":shared"))
//    implementation fileTree(dir: "libs", include: ["**"])
//    implementation fileTree(dir: "libs", include: ["*.jack"])
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.jar"))))
    kapt("androidx.room:room-compiler:2.2.5")
//    kapt ("com.github.bumptech.glide:compiler:4.10.0")
    // Use the Kotlin JDK 8 standard library.
    implementation(kotlin("stdlib-jdk8"))
    implementation(kotlin("script-runtime"))
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.3.7")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.3.9")
    implementation("androidx.concurrent:concurrent-futures-ktx:1.1.0-rc01")
//    implementation("org.jetbrains.kotlin:kotlin-gradle-plugin:1.4.0")

//https://developer.android.com/jetpack/androidx/versions
//https://developer.android.com/kotlin/ktx
// Provides compatibility wrappers for a number of framework APIs,
// such as Context.obtainDrawable() and View.performAccessibilityAction().
    implementation("androidx.core:core-ktx:1.5.0-alpha01")
    implementation("androidx.activity:activity-ktx:1.2.0-alpha07")
// Adds support for encapsulation of user interface and functionality with fragments,
// enabling applications to provide layouts that adjust between small and large-screen devices.
// This module has dependencies on compat, core-utils, core-ui, and media-compat.
    implementation("androidx.fragment:fragment-ktx:1.2.5")
    implementation("androidx.navigation:navigation-runtime-ktx:2.3.0")
    implementation("androidx.navigation:navigation-fragment-ktx:2.3.0")
    implementation("androidx.navigation:navigation-ui-ktx:2.3.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.2.0")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.2.0")
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.2.0")
    implementation("androidx.lifecycle:lifecycle-reactivestreams-ktx:2.2.0")
    implementation ("androidx.room:room-ktx:2.2.5")
    implementation ("androidx.sqlite:sqlite-ktx:2.1.0")
    implementation ("androidx.work:work-runtime-ktx:2.4.0")
// The v7 palette support library includes the Palette class, which lets you extract prominent colors
// from an image. For example, a music app could use a Palette object to extract the major colors from
// an album cover, and use those colors to build a color-coordinated song title card.
    implementation("androidx.palette:palette-ktx:1.0.0")
// https://developers.google.com/android/guides/setup
//    https://developers.google.com/android/guides/setup#split
    //    do not include the full library.. implementation will be terribly slow.. do selective play libs only
// https://firebase.google.com/docs/android/setup
//    https://firebase.google.com/docs/android/setup#kotlin+ktx
    implementation("com.google.firebase:firebase-messaging:20.2.4")
    implementation("com.google.gms:google-services:4.3.3")
    implementation("com.google.android.gms:play-services-gcm:17.0.0")

// The Annotation package provides APIs to support adding annotation metadata to your apps.
    implementation("androidx.annotation:annotation:1.2.0-alpha1")
/*
This library adds support for the Action Bar user interface design pattern. This library includes
support for material design user interface implementations.
Note: This library depends on the v4 Support Library.
Here are a few of the key classes included in the v7 appcompat library:
ActionBar - Provides an implementation of the action bar user interface pattern. For more information on
using the Action Bar, see the Action Bar developer guide.
AppCompatActivity - Adds an application activity class that can be used as a base class for activities
that use the Support Library action bar implementation.
AppCompatDialog - Adds a dialog class that can be used as a base class for AppCompat themed dialogs.
ShareActionProvider - Adds support for a standardized sharing action (such as email or posting to
social applications) that can be included in an action bar.
 */
    implementation("androidx.appcompat:appcompat:1.3.0-alpha01")
//  The Custom Tabs package provides APIs to support adding and managing custom tabs in your apps.
//    The Custom Tabs Support library adds support for various classes, such as Custom Tabs Service and Custom Tabs Callback.
    implementation("androidx.browser:browser:1.3.0-alpha05")
// This library adds support for the CardView widget, which lets you show information inside cards
// that have a consistent look on any app. These cards are useful for material design implementations,
// and are used extensively in layouts for TV apps.
    implementation("androidx.cardview:cardview:1.0.0")
    implementation("androidx.constraintlayout:constraintlayout:2.0.0-rc1")
// After you download the Android Support Libraries, this library adds support for the GridLayout class,
// which allows you to arrange user interface elements using a grid of rectangular cells.
// For detailed information about the v7 gridlayout library APIs, see the android.support.v7.widget package in the API reference.
    implementation("androidx.gridlayout:gridlayout:1.0.0")
    implementation("androidx.lifecycle:lifecycle-extensions:2.2.0")
    /*
This library is designed to be used for Android 3.2 (API level 13) and higher.
It adds support for the Fragment user interface pattern with the (FragmentCompat) class and
additional fragment support classes. For more information about fragments, see the Fragments
developer guide. For detailed information about the v13 Support Library APIs,
see the android.support.v13 package in the API reference.
 */
    implementation("androidx.legacy:legacy-support-v13:1.0.0")
//    implementation("androidx.legacy:legacy-support-v4:1.0.0")
// Provides a number of utility classes, such as AsyncTaskLoader and PermissionChecker.
    implementation("androidx.legacy:legacy-support-core-utils:1.0.0")
//Implements a variety of UI-related components, such as ViewPager, NestedScrollView, and ExploreByTouchHelper.
    implementation("androidx.legacy:legacy-support-core-ui:1.0.0")
    implementation("androidx.legacy:legacy-preference-v14:1.0.0")
/*
This library provides MediaRouter, MediaRouteProvider, and related media classes that support Google Cast.
In general, the APIs in the v7 mediarouter library provide a means of controlling the routing of media
channels and streams from the current device to external screens, speakers, and other destination devices.
The library includes APIs for publishing app-specific media route providers, for discovering and
selecting destination devices, for checking media status, and more. For detailed information about
the v7 mediarouter library APIs, see the android.support.v7.media package in the API reference.
 */
/*
https://developer.android.com/topic/libraries/support-library/revisions.html
Revision 25.2.0
(January 2017)
Important: There is a known bug in the android.support.v7.media.MediaRouter class in
 revision 25.2.0 and 25.1.0 of the Support Library. If your app uses the v7 MediaRouter,
  you should use Support Library Revision 25.0.1 until this bug is resolved in a later
   release.
 */
    implementation("androidx.mediarouter:mediarouter:1.2.0-alpha02")
// Backports portions of the media framework, including MediaBrowser and MediaSession.
    implementation("androidx.media:media:1.2.0-alpha04")
//    // Interacting with MediaSessions
    implementation("androidx.media2:media2-session:1.1.0-alpha01")
//    // optional - UI widgets for VideoView and MediaControlView
    implementation("androidx.media2:media2-widget:1.1.0-alpha01")
//    // optional - Implementation of a SessionPlayer
    implementation("androidx.media2:media2-player:1.1.0-alpha01")
/*
The Design package provides APIs to support adding material design components and patterns to your apps.
The Design Support library adds support for various material design components and patterns for app
developers to build upon, such as navigation drawers, floating action buttons (FAB), snackbars, and tabs.
 */
    implementation("com.google.android.material:material:1.3.0-alpha02")
/*
The preference package provides APIs to support adding preference objects, such as CheckBoxPreference and
ListPreference, for users to modify UI settings.
The v7 Preference library adds support for interfaces, such as Preference.OnPreferenceChangeListener
and Preference.OnPreferenceClickListener, and classes, such as CheckBoxPreference and ListPreference.
 */
    implementation("androidx.preference:preference:1.1.1")
    implementation("androidx.paging:paging-runtime:3.0.0-alpha04")
/*
The Percent package provides APIs to support adding and managing percentage based dimensions in your app.
The Percent Support library adds support for the PercentLayoutHelper.PercentLayoutParams interface and
various classes, such as PercentFrameLayout and PercentRelativeLayout.
 */
    implementation("androidx.percentlayout:percentlayout:1.0.0")
//    The recyclerview library adds the RecyclerView class. This class provides support for the RecyclerView widget,
// a view for efficiently displaying large data sets by providing a limited window of data items.
    implementation("androidx.recyclerview:recyclerview:1.2.0-alpha05")
    implementation("androidx.viewpager2:viewpager2:1.1.0-alpha01")
//https://developer.android.com/studio/build/multidex
//If your minSdkVersion is set to 21 or higher, multidex is enabled by default and you do not need the multidex support library.
    // Enabling multidex support. (only for sdk 20 or lower)
    implementation("androidx.multidex:multidex:2.0.1")

    //    Socket IO
    implementation("io.socket:socket.io-client:1.0.0") {
        // excluding org.json which is provided by Android
        exclude(mapOf("group" to "org.json", "module" to "json"))
    }
    implementation("com.googlecode.libphonenumber:libphonenumber:8.3.2")
    implementation("com.android.volley:volley:1.1.0")
//https://developer.android.com/jetpack/androidx/releases/work
//    // optional - RxJava2 support
//    implementation "androidx.work:work-rxjava2:$work_version"
//    // optional - GCMNetworkManager support
//    implementation "androidx.work:work-gcm:$work_version"
//    // optional - Test helpers
//    androidTestImplementation "androidx.work:work-testing:$work_version"
//    implementation("com.android.support:multidex:1.0.3")
/*
    implementation("com.android.widget.intellibitz.intellidroid.widget.advrecyclerview:intellibitz.intellidroid.widget.advrecyclerview:0.9.1@aar") {
        transitive = true
    }
*/
//    implementation "androidx.room:room-runtime:2.2.5"
//    implementation "com.github.bumptech.glide:glide:4.10.0"
//    implementation "com.google.code.gson:gson:2.8.6"
//    implementation "com.squareup.okhttp3:logging-interceptor:4.7.2"
//    implementation "com.squareup.retrofit2:converter-gson:2.9.0"
//    implementation "com.squareup.retrofit2:retrofit:2.9.0"

    androidTestImplementation(kotlin("test"))
    androidTestImplementation(kotlin("test-junit"))
//        http://android-doc.github.io/tools/building/multidex.html
    androidTestImplementation("androidx.multidex:multidex-instrumentation:2.0.0") {
        exclude(mapOf("group" to "com.android.support", "module" to "multidex"))
    }
//    https://developer.android.com/training/testing/set-up-project
    // Optional -- Robolectric environment
    androidTestImplementation("androidx.test:core:1.2.0")
    // Core library
// Required -- JUnit 4 framework
    androidTestImplementation("junit:junit:4.13")
    // Optional -- Mockito framework
    androidTestImplementation("org.mockito:mockito-core:3.3.3")
// AndroidJUnitRunner and JUnit Rules
    androidTestImplementation("androidx.test:runner:1.2.0")
    androidTestImplementation("androidx.test:rules:1.2.0")
    androidTestImplementation("androidx.arch.core:core-testing:2.1.0")
    androidTestImplementation("androidx.annotation:annotation:1.1.0")
    androidTestImplementation("androidx.appcompat:appcompat:1.3.0-alpha01")
    androidTestImplementation("androidx.recyclerview:recyclerview:1.2.0-alpha05")
    androidTestImplementation("com.google.android.material:material:1.3.0-alpha02")

// Assertions
    androidTestImplementation("androidx.test.ext:junit:1.1.1")
    androidTestImplementation("androidx.test.ext:truth:1.2.0")
    androidTestImplementation("com.google.truth:truth:0.42")
// Espresso core
    androidTestImplementation("androidx.test.espresso:espresso-core:3.2.0")
// Espresso-contrib for DatePicker, RecyclerView, Drawer actions, Accessibility checks, CountingIdlingResource
    androidTestImplementation("androidx.test.espresso:espresso-contrib:3.2.0")
// Espresso-web for WebView support
    androidTestImplementation("androidx.test.espresso:espresso-web:3.2.0")
    androidTestImplementation("androidx.test.espresso.idling:idling-concurrent:3.2.0")
// Espresso-intents for validation and stubbing of Intents
    androidTestImplementation("androidx.test.espresso:espresso-intents:3.2.0")

    // The following Espresso dependency can be either "implementation"
    // or "androidTestImplementation", depending on whether you want the
    // dependency to appear on your APK's compile classpath or the test APK
    // classpath.// Espresso-idling-resource for synchronization with background jobs
    androidTestImplementation("androidx.test.espresso:espresso-idling-resource:3.2.0")
// UiAutomator
    androidTestImplementation("androidx.test.uiautomator:uiautomator:2.2.0")
    // Optional -- Hamcrest library
    androidTestImplementation("org.hamcrest:hamcrest-library:1.4-atlassian-1")

    androidTestImplementation("androidx.test.espresso:espresso-core:3.1.0") {
        exclude(mapOf("group" to "com.android.support", "module" to "support-annotations"))
    }

    testImplementation(kotlin("test"))
    testImplementation(kotlin("test-junit"))
// Required -- JUnit 4 framework
    testImplementation("junit:junit:4.13")
    testImplementation("androidx.test.espresso:espresso-core:3.2.0")
    // Optional -- Robolectric environment
    testImplementation("androidx.test:core:1.2.0")
    // Optional -- Mockito framework
    testImplementation("org.mockito:mockito-core:3.3.3")
// AndroidJUnitRunner and JUnit Rules
    testImplementation("androidx.test:runner:1.2.0")
    testImplementation("androidx.test:rules:1.2.0")
/*
    testImplementation("androidx.multidex:multidex-instrumentation:2.0.0") {
        exclude(mapOf("group" to "com.android.support", "module" to "multidex"))
    }
*/
//    testImplementation("androidx.test.ext:junit:1.1.1")
//    testImplementation("androidx.arch.core:core-testing:2.1.0")
//    testImplementation("androidx.annotation:annotation:1.1.0")
    testImplementation("org.json:json:20180813")
    testImplementation("org.mockito:mockito-core:3.3.3")
    testImplementation("org.robolectric:robolectric:4.2.1")


    debugImplementation("com.facebook.stetho:stetho:1.4.2")
    debugImplementation("com.facebook.stetho:stetho-okhttp3:1.4.2")
    debugImplementation("com.facebook.stetho:stetho-urlconnection:1.4.2")
    debugImplementation("com.facebook.stetho:stetho-js-rhino:1.4.2")

//    implementation ("com.android.support:support-core-utils:28.0.0")
    // Set this dependency to use JUnit 4 rules
//    androidTestImplementation "com.android.support.test:rules:0.6-alpha"
    // Set this dependency to build and run Espresso tests
//    androidTestImplementation "com.android.support.test.espresso:espresso-core:2.3-alpha"
    // Set this dependency to build and run UI Automator tests
//    androidTestImplementation "com.android.support.test.uiautomator:uiautomator-v18:2.1.2"
//    Junit framework testcase support libraries
//    androidTestImplementation ("com.android.support.test:runner:1.0.2")

//    implementation "com.google.android.gms:play-services:8.4.0"
//    implementation "com.google.android.gms:play-services:9.0.2"
//    implementation "com.google.android.gms:play-services-gcm:9.0.2"
    //    implementation "com.amazonaws:aws-android-sdk-core:2.2.14"
//    implementation "com.amazonaws:aws-android-sdk-cognito:2.2.14"
//    implementation "com.amazonaws:aws-android-sdk-s3:2.2.14"
//    implementation "com.amazonaws:aws-android-sdk-ddb:2.2.14"
//    annotationProcessor "intellibitz.intellidroid:1.0"
//    implementation("androidx.core:core-ktx:+")
    //    AWS SDK
    //    the following android support requires minsdkversion 13 or higher.. currently 11
//    implementation "com.android.support:support-v13:"+23.2.1
//    implementation "com.android.support:preference-v14:"+23.2.1
//    implementation "com.android.support:customtabs:"+23.2.1
/*
    implementation("io.socket:engine.io-client:0.7.0") {
        // excluding org.json which is provided by Android
        exclude group: "org.json", module: "json"
    }
    implementation "com.mcxiaoke.volley:library:1.0.19"
    implementation "com.squareup.picasso:picasso:2.5.2"
    implementation "com.squareup.retrofit2:retrofit:2.0.0-beta3"
    implementation "com.squareup.okio:okio:1.6.0"
    implementation "com.squareup.okhttp3:okhttp:3.0.1"
    implementation "com.squareup.okhttp3:okhttp-ws:3.0.1"
*/

}

