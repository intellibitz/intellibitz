#https://docs.gradle.org/current/userguide/userguide.html
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

https://docs.gradle.org/current/userguide/getting_started_eng.html
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

#Version catalogs provide a way to centralize your dependency declarations in a libs.versions.toml file.
#The version catalog typically contains four sections:
#[versions] to declare the version numbers that plugins and libraries will reference.
#[libraries] to define the libraries used in the build files.
#[bundles] to define a set of dependencies.
#[plugins] to define plugins.

#The file is located in the gradle directory so that it can be used by Gradle and IDEs automatically. The
# version catalog should be checked into source control: gradle/libs.versions.toml.
<< 'libs.versions.toml'
[versions]
androidGradlePlugin = "7.4.1"
mockito = "2.16.0"

[libraries]
googleMaterial = { group = "com.google.android.material", name = "material", version = "1.1.0-alpha05" }
mockitoCore = { module = "org.mockito:mockito-core", version.ref = "mockito" }

[plugins]
androidApplication = { id = "com.android.application", version.ref = "androidGradlePlugin" }
libs.versions.toml

#The following build.gradle.kts file adds a plugin and two dependencies to the project using the version catalog above:
<< 'build.gradle.kts'
plugins {
   alias(libs.plugins.androidApplication)
}

dependencies {
    // Dependency on a remote binary to compile and run the code
    implementation(libs.googleMaterial)

    // Dependency on a remote binary to compile and run the test code
    testImplementation(libs.mockitoCore)
}
build.gradle.kts

#You can view your dependency tree in the terminal using the ./gradlew :app:dependencies command:
$ ./gradlew :app:dependencies

#You run a Gradle build task using the gradle command or by invoking the Gradle Wrapper (./gradlew or gradlew.bat) in your project directory:
$ ./gradlew build

#All available tasks in your project come from Gradle plugins and build scripts.
#You can list all the available tasks in the project by running the following command in the terminal:
$ ./gradlew tasks
#You can also list the tasks only available in the app subproject by running
$ ./gradlew :app:tasks.
#You can obtain more information in the task listing using the --all option:
$ ./gradlew tasks --all

#The run task is executed with ./gradlew run:
$ ./gradlew run

#Many times, a task requires another task to run first.
$ ./gradlew build

#Plugins can be applied to a Gradle build script to add new tasks, configurations, or other build-related capabilities:
The Java Library Plugin - java-library
#Used to define and build Java libraries. It compiles Java source code with the compileJava task, generates Javadoc with the
# javadoc task, and packages the compiled classes into a JAR file with the jar task.

The Google Services Gradle Plugin - com.google.gms:google-services
#Enables Google APIs and Firebase services in your Android application with a configuration block called
# googleServices{} and a task called generateReleaseAssets.

The Gradle Bintray Plugin - com.jfrog.bintray
#Allows you to publish artifacts to Bintray by configuring the plugin using the bintray{} block.

#You apply plugins in the build script using a plugin id (a globally unique identifier / name) and a version:
<< 'build.gradle.kts'
plugins {
    id «plugin id» version «plugin version»
}
build.gradle.kts

#Core plugins are unique in that they provide short names, such as java for the core JavaPlugin, when applied in
# build scripts. They also do not require versions. To apply the java plugin to a project:
<< 'build.gradle.kts'
plugins {
    id("java")
}
build.gradle.kts

#Community plugins can be published at the Gradle Plugin Portal, where other Gradle users can easily discover and use them.
<< 'build.gradle.kts'
plugins {
    id("org.springframework.boot") version "3.1.5"
}
build.gradle.kts

#Incremental builds are always enabled, and the best way to see them in action is to turn on verbose mode.
# With verbose mode, each task state is labeled during a build:
$ ./gradlew compileJava --console=verbose

#When the build cache has been used to repopulate the local directory, the tasks are marked as FROM-CACHE:
$ ./gradlew compileJava --build-cache

#A build scan is a representation of metadata captured as you run your build.
#A Build Scan is a shareable and centralized record of a build and is available as a free service from Gradle.
#To enable build scans on a gradle command, add --scan to the command line option:
$ ./gradlew build --scan

https://docs.gradle.org/current/userguide/part1_gradle_init.html
$ gradle
$ gradle init --type java-application  --dsl kotlin

https://docs.gradle.org/current/userguide/part2_gradle_tasks.html#part2_begin
<< 'build.gradle.kts'
tasks.register<Copy>("copyTask") {
    from("source")
    into("target")
    include("*.war")
}

tasks.register("hello") {
    doLast {
        println("Hello!")
    }
}

tasks.register("greet") {
    doLast {
        println("How are you?")
    }
    dependsOn("hello")
}
build.gradle.kts

https://docs.gradle.org/current/userguide/part3_gradle_dep_man.html#part3_begin
<< 'build.gradle.kts'
repositories {
    // Use Maven Central for resolving dependencies.
    mavenCentral()
}

dependencies {
    // Use JUnit Jupiter for testing.
    testImplementation(libs.junit.jupiter)
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
    // This dependency is used by the application.
    implementation(libs.guava)
}

Some key concepts in Gradle dependency management include:

Repositories - The source of dependencies → mavenCentral()
Maven Central is a collection of jar files, plugins, and libraries provided by the Maven community and backed by
 Sonatype. It is the de-facto public artifact store for Java and is used by many build systems.
Dependencies - Dependencies declared via configuration types → libs.junit.jupiter and libs.guava

Gradle needs specific information to find a dependency. Let’s look at
 libs.guava → com.google.guava:guava:32.1.2-jre and
  libs.junit.jupiter → org.junit.jupiter:junit-jupiter-api:5.9.1; they are broken down as follows:

Description	                            com.google.guava:guava:32.1.2-jre,	org.junit.jupiter:junit-jupiter-api:5.9.1
Group / identifier of an organization   com.google.guava , org.junit.jupiter
Name  / dependency identifier           guava , junit-jupiter-api
Version / version # to import           32.1.2-jre , 5.9.1
build.gradle.kts

https://docs.gradle.org/current/userguide/part4_gradle_plugins.html#part4_begin
#The Maven Publish Plugin provides the ability to publish build artifacts to an Apache Maven repository. It can also
# publish to Maven local which is a repository located on your machine.
<< 'build.gradle.kts'
plugins {
    // Apply the application plugin to add support for building a CLI application in Java.
    application
    id("maven-publish")
}

publishing {
    publications {
        create<MavenPublication>("maven") {
            groupId = "com.gradle.tutorial"
            artifactId = "tutorial"
            version = "1.0"

            from(components["java"])
        }
    }
}
build.gradle.kts

#The publishToMavenLocal task builds the POM file and the artifacts to be published. It then installs them into the local Maven repository.
$ ./gradlew :app:publishToMavenLocal

#Plugins are used to extend build capability and customize Gradle. Using plugins is the primary mechanism for organizing build logic.
#Plugin authors can either keep their plugins private or distribute them to the public. As such, plugins are distributed three ways:

Core plugins - Gradle develops and maintains a set of Core Plugins.
Community plugins - Gradle’s community shares plugins via the Gradle Plugin Portal.
Custom plugins - Gradle enables user to create custom plugins using APIs.
Convention plugins are plugins used to share build logic between subprojects /modules .

#Users can wrap common logic in a convention plugin. For example, a code coverage plugin used as a convention plugin can
# survey code coverage for the entire project and not just a specific subproject.

Gradle highly recommends the use of Convention plugins.

https://docs.gradle.org/current/userguide/part5_gradle_inc_builds.html#part5_begin
$ ./gradlew :app:clean :app:build
$ ./gradlew :app:build

#There are four labels that developers can use to view task outcomes when verbose mode is turned on:
#OutcomeLabel	Description
UP-TO-DATE    Task that has been already executed and hasn’t changed ~incremental build feature
SKIPPED       Task was explicitly prevented from running
FROM-CACHE    Task output has been copied to local directory from previous builds in the build cache ~caching feature
NO-SOURCE     Task was not executed because its required inputs were not available
#If there is no label, the task was newly executed by Gradle ~locally.

https://docs.gradle.org/current/userguide/part6_gradle_caching.html#part6_begin
https://docs.gradle.org/current/userguide/gradle_directories.html
#Add org.gradle.caching=true to the gradle.properties file:
<< 'gradle.properties'
org.gradle.console=verbose
org.gradle.caching=true
gradle.properties

$ ./gradlew :app:clean :app:build
$ ./gradlew :app:build

#Gradle lets us know the outcome of each task in the console output:
FROM-CACHE - tasks have been fetched from the local build cache.
UP-TO-DATE - tasks that used incremental build and were not re-run.

#To summarize:
First, we used the build task to populate our local cache with task inputs and outputs, we can imagine this was done a week ago.
Then, we used the clean task to mimic switching branches, overriding previous outputs.
Finally, we used the build task, unlike incremental builds, the previous outputs were stored in the local cache and could be reused.

Gradle is efficient, especially with the local build cache turned on. Gradle will look at the cache directory on your
 machine to check for output files that may already exist. If they do, instead of running that task, it will copy its
  ~output results into your project build directory.
The outcome label FROM-CACHE lets the user know that Gradle has fetched the task results from the local build cache.

https://docs.gradle.org/current/userguide/part7_gradle_refs.html#part7_begin
#http://gradle.org/docs/current/javadoc/
https://docs.gradle.org/current/dsl/index.html
https://docs.gradle.org/current/kotlin-dsl/index.html
https://docs.gradle.org/current/userguide/plugin_reference.html#plugin_reference
#https://plugins.gradle.org/
#https://gradle.org/releases/
http://gradle.org/docs/current/release-notes
#https://discuss.gradle.org/
#https://gradle-community.slack.com/
#https://gradle.org/courses/

https://docs.gradle.org/current/userguide/command_line_interface.html#command_line_interface

#Authoring Gradle Builds
https://docs.gradle.org/current/userguide/getting_started_dev.html
Gradle User Home directory
By default, the Gradle User Home \(~/.gradle or C:\Users\<USERNAME>\.gradle\) stores global configuration properties,
 initialization scripts, caches, and log files.
It can be set with the environment variable GRADLE_USER_HOME.
Not to be confused with the GRADLE_HOME, the optional installation directory for Gradle.
It is roughly structured as follows:

├── caches
│   ├── 4.8
│   ├── 4.9
│   ├── ⋮
│   ├── jars-3
│   └── modules-2
├── daemon
│   ├── ⋮
│   ├── 4.8
│   └── 4.9
├── init.d
│   └── my-setup.gradle
├── jdks
│   ├── ⋮
│   └── jdk-14.0.2+12
├── wrapper
│   └── dists
│       ├── ⋮
│       ├── gradle-4.8-bin
│       ├── gradle-4.9-all
│       └── gradle-4.9-bin
└── gradle.properties

Global cache directory \(for everything that is not project-specific\).
Version-specific caches \(e.g., to support incremental builds\).
Shared caches \(e.g., for artifacts of dependencies\).
Registry and logs of the Gradle Daemon.
Global initialization scripts.
JDKs downloaded by the toolchain support.
Distributions downloaded by the Gradle Wrapper.
Global Gradle configuration properties.
Consult the Gradle Directories reference to learn more.
https://docs.gradle.org/current/userguide/directory_layout.html#dir:gradle_user_home

Project Root directory
The project root directory contains all source files from your project.
It also contains files and directories Gradle generates, such as .gradle and build.
~While gradle is usually checked into source control, the build directory contains the output of your builds as well as
 transient files Gradle uses to support features like incremental builds.
The anatomy of a typical project root directory looks as follows:

├── .gradle
│   ├── 4.8
│   ├── 4.9
│   └── ⋮
├── build
├── gradle
│   └── wrapper
├── gradle.properties
├── gradlew
├── gradlew.bat
├── settings.gradle.kts
├── subproject-one
   └── build.gradle.kts
├── subproject-two
   └── build.gradle.kts
└── ⋮

Project-specific cache directory generated by Gradle.
Version-specific caches \(e.g., to support incremental builds\).
The build directory of this project into which Gradle generates all build artifacts.
Contains the JAR file and configuration of the Gradle Wrapper.
Project-specific Gradle configuration properties.
Scripts for executing builds using the Gradle Wrapper.
The projects settings file where the list of subprojects is defined.
Usually, a project is organized into one or multiple subprojects.
Each subproject has its own Gradle build script.
Consult the Gradle Directories reference to learn more.
https://docs.gradle.org/current/userguide/directory_layout.html#dir:project_root

https://docs.gradle.org/current/userguide/intro_multi_project_builds.html
#A multi-project build consists of one root project and one or more subprojects.
The following represents the structure of a multi-project build that contains two subprojects:
The directory structure should look as follows:

├── .gradle
│   └── ⋮
├── gradle
│   ├── libs.version.toml
│   └── wrapper
├── gradlew
├── gradlew.bat
├── settings.gradle.kts
├── sub-project-1
│   └── build.gradle.kts
├── sub-project-2
│   └── build.gradle.kts
└── sub-project-3
    └── build.gradle.kts

The settings.gradle.kts file should include all subprojects.
Each subproject should have its own build.gradle.kts file.
#The Gradle community has two standards for multi-project build structures:
Multi-Project Builds using buildSrc - where buildSrc is a subproject-like directory at the Gradle project root containing all the build logic.
~For example, a build that has many modules called mobile-app, web-app, api, lib, and documentation could be structured as follows:

.
├── gradle
├── gradlew
├── settings.gradle.kts
├── buildSrc
│   ├── build.gradle.kts
│   └── src/main/kotlin/shared-build-conventions.gradle.kts
├── mobile-app
│   └── build.gradle.kts
├── web-app
│   └── build.gradle.kts
├── api
│   └── build.gradle.kts
├── lib
│   └── build.gradle.kts
└── documentation
    └── build.gradle.kts

The modules will have dependencies between them such as web-app and mobile-app depending on lib. This means that in
 order for Gradle to build web-app or mobile-app, it must build lib first.

In this example, the root settings file will look as follows:

<< 'settings.gradle.kts'
include("mobile-app", "web-app", "api", "lib", "documentation")
settings.gradle.kts
The order in which the subprojects ~modules~ are included does not matter.

Composite Builds - a build that includes other builds where build-logic is a build directory at the Gradle project root containing reusable build logic.
#Multi-Project Builds using buildSrc
Multi-project builds allow you to organize projects with many modules, wire dependencies between those modules, and
easily share common build logic amongst themi-project builds allow you to organize projects with many modules,
wire dependencies between those modules, and easily share common build logic amongst them

https://docs.gradle.org/current/userguide/sharing_build_logic_between_subprojects.html#sec:using_buildsrc
The buildSrc directory is automatically recognized by Gradle. It is a good place to define and maintain shared configuration or
 imperative build logic, such as custom tasks or plugins.
buildSrc is automatically included in your build as a special subproject if a build.gradle.kts file is found under buildSrc.
~If the java plugin is applied to the buildSrc project, the compiled code from buildSrc/src/main/java is put in the
 classpath of the root build script, making it available to any subproject ~web-app, mobile-app, lib, etc., in the build.

https://docs.gradle.org/current/userguide/composite_builds.html#defining_composite_builds
Composite Builds, also referred to as included builds, are best for sharing logic between builds ~not subprojects~ or
 isolating access to shared build logic ~i.e., convention plugins~.

Let’s take the previous example. The logic in buildSrc has been turned into a project that contains plugins and can be
 published and worked on independently of the root project build.
The plugin is moved to its own build called build-logic with a build script and settings file:

.
├── gradle
├── gradlew
├── settings.gradle.kts
├── build-logic
│   ├── settings.gradle.kts
│   └── conventions
│       ├── build.gradle.kts
│       └── src/main/kotlin/shared-build-conventions.gradle.kts
├── mobile-app
│   └── build.gradle.kts
├── web-app
│   └── build.gradle.kts
├── api
│   └── build.gradle.kts
├── lib
│   └── build.gradle.kts
└── documentation
    └── build.gradle.kts

The fact that build-logic is located in a subdirectory of the root project is irrelevant.
The folder could be located outside the root project if desired.
<< 'settings.gradle.kts'
pluginManagement {
    includeBuild("build-logic")
}
include("mobile-app", "web-app", "api", "lib", "documentation")
settings.gradle.kts

A project path has the following pattern: it starts with an optional colon, which denotes the root project.
The root project, :, is the only project in a path not specified by its name.
The rest of a project path is a colon-separated sequence of project names, where the next project is a subproject of the previous project:
:sub-project-1

gradlew -q projects

https://docs.gradle.org/current/userguide/multi_project_builds.html#multi_project_builds
#Multi-project builds are collections of tasks you can run. The difference is that you may want to control which project’s tasks get executed.
#Executing tasks by name
The command gradle test will execute the test task in any subprojects relative to the current working directory that has that task.
~If you run the command from the root project directory, you will run test in api, shared, services:shared and services:webservice.
~If you run the command from the services project directory, you will only execute the task in services:shared and services:webservice.
The basic rule behind Gradle’s behavior is to execute all tasks down the hierarchy with this name. And complain if there
 is no such task found in any of the subprojects traversed.
Some task selectors, like help or dependencies, will only run the task on the project they are invoked on and not on all the
 subprojects to reduce the amount of information printed on the screen.
#Executing tasks by fully qualified name
You can use a task’s fully qualified name to execute a specific task in a particular subproject.
~For example: gradle :services:webservice:build will run the build task of the webservice subproject.
The fully qualified name of a task is its project path plus the task name.
This approach works for any task, so if you want to know what tasks are in a particular subproject, use the
 tasks task, e.g. gradle :services:webservice:tasks.

The build task is typically used to compile, test, and check a single project.
$ gradle :api:build
The buildNeeded task builds AND tests all the projects from the project dependencies of the testRuntime configuration:
$ gradle :api:buildNeeded
The buildDependents task tests ALL the projects that have a project dependency ~in the testRuntime configuration~ on the specified project:
$ gradle :api:buildDependents
Finally, you can build and test everything in all projects. Any task you run in the root project folder will
 cause that same-named task to be run on all the children.
You can run gradle build to build and test ALL projects.
$ gradle build

https://docs.gradle.org/current/userguide/build_lifecycle.html#build_lifecycle
https://docs.gradle.org/current/userguide/tutorial_using_tasks.html#sec:task_dependencies
https://docs.gradle.org/current/userguide/incremental_build.html#sec:task_inputs_outputs
#A Gradle build has three distinct phases. Gradle runs these phases in order:
Phase 1. Initialization
In the initialization phase, Gradle detects the set of projects ~root and subprojects~ and
 included builds participating in the build.
Detects the settings.gradle~.kts~ file. Creates a Settings instance.
Evaluates the settings file to determine which projects ~and included builds~ make up the build.
Creates a Project instance for every project.

Phase 2. Configuration
In the configuration phase, Gradle adds tasks and other properties to the projects found by the initialization phase.
Evaluates the build scripts, build.gradle~.kts~, of every project participating in the build.
Creates a task graph for requested tasks.

Phase 3. Execution
In the execution phase, Gradle runs tasks.
Gradle uses the task execution graphs generated by the configuration phase to determine which tasks to execute.
Schedules and executes the selected tasks.
Dependencies between tasks determine execution order.
Execution of tasks can occur in parallel.

The following example shows which parts of settings and build files correspond to various build phases:
<< 'settings.gradle.kts'
rootProject.name = "basic"
println("This is executed during the initialization phase.")
settings.gradle.kts
<< 'build.gradle.kts'
println("This is executed during the configuration phase.")

tasks.register("configured") {
    println("This is also executed during the configuration phase, because :configured is used in the build.")
}

tasks.register("test") {
    doLast {
        println("This is executed during the execution phase.")
    }
}

tasks.register("testBoth") {
    doFirst {
        println("This is executed first during the execution phase.")
    }
    doLast {
        println("This is executed last during the execution phase.")
    }
    println("This is executed during the configuration phase as well, because :testBoth is used in the build.")
}
build.gradle.kts

The following command executes the test and testBoth tasks specified above. Because Gradle only configures requested
 tasks and their dependencies, the configured task never configures:
> gradle test testBoth
This is executed during the initialization phase.
> Configure project :
This is executed during the configuration phase.
This is executed during the configuration phase as well, because :testBoth is used in the build.
> Task :test
This is executed during the execution phase.
> Task :testBoth
This is executed first during the execution phase.
This is executed last during the execution phase.

https://docs.gradle.org/current/userguide/writing_settings_files.html#writing_settings_files
The settings file is the entry point of every Gradle build.
Early in the Gradle Build lifecycle, the initialization phase finds the settings file in your project root directory.
When the settings file ~settings.gradle.kts is found, Gradle instantiates a Settings object.
One of the purposes of the Settings object is to allow you to declare all the projects to be included in the build.
Before Gradle assembles the projects for a build, it creates a Settings instance and executes the settings file against it.
As the settings script executes, it configures this Settings. Therefore, the settings file defines the Settings object.
There is a one-to-one correspondence between a Settings instance and a ~settings.gradle.kts file.

https://docs.gradle.org/current/javadoc/org/gradle/api/initialization/Settings.html
The Settings object is part of the Gradle API.
In the Kotlin DSL, the Settings object documentation is found here.
https://docs.gradle.org/current/kotlin-dsl/gradle/org.gradle.api.initialization/-settings/index.html
Many top-level properties and blocks in a settings script are part of the Settings API.
~For example, we can set the root project name in the settings script using the Settings.rootProject property:
<< 'settings.gradle.kts'
settings.rootProject.name = "root"
#Which is usually shortened to:
rootProject.name = "root"
settings.gradle.kts

#The Settings object exposes a standard set of properties in your settings script.
The following table lists a few commonly used properties:
Name	Description
buildCache
The build cache configuration.
plugins
The container of plugins that have been applied to the settings.
rootDir
The root directory of the build. The root directory is the project directory of the root project.
rootProject
The root project of the build.
settings
Returns this settings object.

The following table lists a few commonly used methods:
Name	Description
~include\(\)
Adds the given projects to the build.
~includeBuild\(\)
Includes a build at the specified path to the composite build.

A Settings script is a series of method calls to the Gradle API that often use {  }, a special shortcut in both the
 Groovy and Kotlin languages. A { } block is called a lambda in Kotlin or a closure in Groovy.
Simply put, the plugins{ } block is a method invocation in which a Kotlin lambda object or Groovy closure object is
 passed as the argument. It is the short form for:
<< 'settings.gradle.kts'
plugins(function() {
    id("plugin")
})
settings.gradle.kts
Blocks are mapped to Gradle API methods.
The code inside the function is executed against a this object called a receiver in Kotlin lambda and a delegate in
 Groovy closure. Gradle determines the correct this object and invokes the correct corresponding method. The this of the
  method invocation id\("plugin"\) object is of type PluginDependenciesSpec.

The settings file is composed of Gradle API calls built on top of the DSLs. Gradle executes the script line by line, top to bottom.
<< 'settings.gradle.kts'
pluginManagement {
    repositories {
        gradlePluginPortal()
        google()
    }
}

plugins {
    id("org.gradle.toolchains.foojay-resolver-convention") version "0.8.0"
}

rootProject.name = "root-project"

dependencyResolutionManagement {
    repositories {
        mavenCentral()
    }
}

include("sub-project-a")
include("sub-project-b")
include("sub-project-c")
settings.gradle.kts

1. Define the location of plugins
The settings file can optionally manage plugin versions and repositories for your build with pluginManagement It
 provides a centralized way to define which plugins should be used in your project and from which repositories they should be resolved.

<< 'settings.gradle.kts'
pluginManagement {
    repositories {
        gradlePluginPortal()
        google()
    }
}
settings.gradle.kts
2. Apply settings plugins
The settings file can optionally apply plugins that are required for configuring the settings of the project. These are
 commonly the Develocity plugin and the Toolchain Resolver plugin in the example below.
Plugins applied in the settings file only affect the Settings object.

<< 'settings.gradle.kts'
plugins {
  id("org.gradle.toolchains.foojay-resolver-convention") version "0.8.0"
}
settings.gradle.kts
3. Define the root project name
The settings file defines your project name using the rootProject.name property:

<< 'settings.gradle.kts'
rootProject.name = "root-project"
settings.gradle.kts
There is only one root project per build.
4. Define dependency resolution strategies
The settings file can optionally define rules and configurations for dependency resolution across your projects. It
 provides a centralized way to manage and customize dependency resolution.

<< 'settings.gradle.kts'
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_PROJECT)
    repositories {
        mavenCentral()
    }
}
settings.gradle.kts
You can also include version catalogs in this section.
5. Add subprojects to the build
The settings file defines the structure of the project by adding all the subprojects using the include statement:

<< 'settings.gradle.kts'
include("app")
include("business-logic")
include("data-model")
settings.gradle.kts
You can also include entire builds using includeBuild.

There are many more properties and methods on the Settings object that you can use to configure your build.
It’s important to remember that while many Gradle scripts are typically written in short Groovy or Kotlin syntax, every
 item in the settings script is essentially invoking a method on the Settings object in the Gradle API:

<< 'settings.gradle.kts'
include("app")
#Is actually:
settings.include("app")
settings.gradle.kts
Additionally, the full power of the Groovy and Kotlin languages is available to you.
~For example, instead of using include many times to add subprojects, you can iterate over the list of directories in
 the project root folder and include them automatically:

<< 'settings.gradle.kts'
rootDir.listFiles().filter { it.isDirectory && (new File(it, "build.gradle.kts").exists()) }.forEach {
    include(it.name)
}
settings.gradle.kts
~This type of logic should be developed in a plugin.

https://docs.gradle.org/current/userguide/writing_build_scripts.html#writing_build_scripts
The initialization phase in the Gradle Build lifecycle finds the root project and subprojects included in your
 project root directory using the settings file.
https://docs.gradle.org/current/userguide/directory_layout.html#dir:project_root
Then, for each project included in the settings file, Gradle creates a Project instance. Gradle then looks for a
 corresponding build script file, which is used in the configuration phase.

Every Gradle build comprises one or more projects; a root project and subprojects.
A project typically corresponds to a software component that needs to be built, like a library or an application. It
 might represent a library JAR, a web application, or a distribution ZIP assembled from the JARs produced by other projects.
On the other hand, it might represent a thing to be done, such as deploying your application to staging or production environments.
Gradle scripts are written in either Groovy DSL or Kotlin DSL ~domain-specific language~.
A build script configures a project and is associated with an object of type Project.
As the build script executes, it configures Project.
The build script is either a *.gradle file in Groovy or a *.gradle.kts file in Kotlin.
Build scripts configure Project objects and their children.

The Project object is part of the Gradle API:
https://docs.gradle.org/current/javadoc/org/gradle/api/Project.html
In the Kotlin DSL, the Project object documentation is found here.
https://docs.gradle.org/current/kotlin-dsl/gradle/org.gradle.api/-project/index.html
Many top-level properties and blocks in a build script are part of the Project API.
~For example, the following build script uses the Project.name property to print the name of the project:
https://docs.gradle.org/current/dsl/org.gradle.api.Project.html#org.gradle.api.Project:name

<< 'build.gradle.kts'
println(name)
println(project.name)
#The first uses the top-level reference to the name property of the Project object. The second statement uses the
# project property available to any build script, which returns the associated Project object.
build.gradle.kts

$ gradle -q check

#The Project object exposes a standard set of properties in your build script.
The following table lists a few commonly used properties:
#Name	Type	Description
name String
The name of the project directory.
path String
The fully qualified name of the project.
description String
A description for the project.
dependencies DependencyHandler
Returns the dependency handler of the project.
repositories RepositoryHandler
Returns the repository handler of the project.
layout ProjectLayout
Provides access to several important locations for a project.
group Object
The group of this project.
version Object
The version of this project.

The following table lists a few commonly used methods:
#Name	Description
uri\(\)
Resolves a file path to a URI, relative to the project directory of this project.
task\(\)
Creates a Task with the given name and adds it to this project.

<< 'build.gradle.kts'
plugins {
    id("org.jetbrains.kotlin.jvm") version "2.0.20"
    id("application")
}
repositories {
    mavenCentral()
}
dependencies {
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
    testImplementation("org.junit.jupiter:junit-jupiter-engine:5.9.3")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
    implementation("com.google.guava:guava:32.1.1-jre")
}
application {
    mainClass = "com.example.Main"
}
tasks.named<Test>("test") {
    useJUnitPlatform()
}
build.gradle.kts

1. Apply plugins to the build
Plugins are used to extend Gradle. They are also used to modularize and reuse project configurations.
Plugins can be applied using the PluginDependenciesSpec plugins script block.
The plugins block is preferred:
<< 'build.gradle.kts'
plugins {
    id("org.jetbrains.kotlin.jvm") version "2.0.20"
    id("application")
}
build.gradle.kts
In the example, the application plugin, which is included with Gradle, has been applied, describing our project as a Java application.
The Kotlin gradle plugin, version 2.0.20, has also been applied. This plugin is not included with Gradle and, therefore, has to be
 described using a plugin id and a plugin version so that Gradle can find and apply it.

2. Define the locations where dependencies can be found
A project generally has a number of dependencies it needs to do its work. Dependencies include plugins, libraries, or
 components that Gradle must download for the build to succeed.
The build script lets Gradle know where to look for the binaries of the dependencies. More than one location can be provided:
<< 'build.gradle.kts'
repositories {
    mavenCentral()
    google()
}
build.gradle.kts
In the example, the guava library and the JetBrains Kotlin plugin ~org.jetbrains.kotlin.jvm~ will be downloaded from the Maven Central Repository.

3. Add dependencies
A project generally has a number of dependencies it needs to do its work. These dependencies are often libraries of
precompiled classes that are imported in the projects source code.
Dependencies are managed via configurations and are retrieved from repositories.
https://docs.gradle.org/current/userguide/glossary.html#sub:terminology_configuration
Use the DependencyHandler returned by Project.getDependencies\(\) method to manage the dependencies. Use the
 RepositoryHandler returned by Project.getRepositories\(\) method to manage the repositories.
<< 'build.gradle.kts'
dependencies {
    implementation("com.google.guava:guava:32.1.1-jre")
}
build.gradle.kts
In the example, the application code uses Google guava libraries. Guava provides utility methods for collections,
caching, primitives support, concurrency, common annotations, string processing, I/O, and validations.

4. Set properties
A plugin can add properties and methods to a project using extensions.
The Project object has an associated ExtensionContainer object that contains all the settings and properties for the
plugins that have been applied to the project.
In the example, the application plugin added an application property, which is used to detail the main class of our Java application:
<< 'build.gradle.kts'
application {
    mainClass = "com.example.Main"
}
build.gradle.kts

5. Register and configure tasks
Tasks perform some basic piece of work, such as compiling classes, or running unit tests, or zipping up a WAR file.
~While tasks are typically defined in plugins, you may need to register or configure tasks in build scripts.
Registering a task adds the task to your project.
You can register tasks in a project using the TaskContainer.register\(java.lang.String\) method:
<< 'build.gradle.kts'
tasks.register<Zip>("zip-reports") {
    from 'Reports/'
    include '*'
    archiveName 'Reports.zip'
    destinationDir(file('/dir'))
}
build.gradle.kts
You may have seen usage of the TaskContainer.create\(java.lang.String\) method which should be avoided:
<< 'build.gradle.kts'
tasks.create<Zip>("zip-reports") {
    from 'Reports/'
    include '*'
    archiveName 'Reports.zip'
    destinationDir(file('/dir'))
}
#register(), which enables task configuration avoidance, is preferred over create().
build.gradle.kts
You can locate a task to configure it using the TaskCollection.named\(java.lang.String\) method:
<< 'build.gradle.kts'
tasks.named<Test>("test") {
    useJUnitPlatform()
}
build.gradle.kts
The example below configures the Javadoc task to automatically generate HTML documentation from Java code:
<< 'build.gradle.kts'
tasks.named("javadoc").configure {
    exclude 'app/Internal*.java'
    exclude 'app/internal/*'
    exclude 'app/internal/*'
}
build.gradle.kts

A build script is made up of zero or more statements and script blocks:
<< 'build.gradle.kts'
println(project.layout.projectDirectory);
#Statements can include method calls, property assignments, and local variable definitions:
version = '1.0.0.GA'
#A script block is a method call which takes a closure/lambda as a parameter:
configurations {
}
#The closure/lambda configures some delegate object as it executes:
repositories {
    google()
}
build.gradle.kts

A build script is also a Groovy or a Kotlin script:
<< 'build.gradle.kts'
tasks.register("upper") {
    doLast {
        val someString = "mY_nAmE"
        println("Original: $someString")
        println("Upper case: ${someString.toUpperCase()}")
    }
}
build.gradle.kts
$ gradle -q upper

It can contain elements allowed in a Groovy or Kotlin script, such as method definitions and class definitions:
<< 'build.gradle.kts'
tasks.register("count") {
    doLast {
        repeat(4) { print("$it ") }
    }
}
build.gradle.kts
$ gradle -q count

Using the capabilities of the Groovy or Kotlin language, you can register multiple tasks in a loop:
<< 'build.gradle.kts'
repeat(4) { counter ->
    tasks.register("task$counter") {
        doLast {
            println("I'm task number $counter")
        }
    }
}
build.gradle.kts
$ gradle -q task1

Build scripts can declare two variables: local variables and extra properties.

Local Variables
Declare local variables with the val keyword. Local variables are only visible in the scope where they have been
 declared. They are a feature of the underlying Kotlin language.
<< 'build.gradle.kts'
val dest = "dest"

tasks.register<Copy>("copy") {
    from("source")
    into(dest)
}
build.gradle.kts

Extra Properties
Gradle’s enhanced objects, including projects, tasks, and source sets, can hold user-defined properties.
Add, read, and set extra properties via the owning object’s extra property. Alternatively, you can access extra
 properties via Kotlin delegated properties using by extra.
<< 'build.gradle.kts'
plugins {
    id("java-library")
}

val springVersion by extra("3.1.0.RELEASE")
val emailNotification by extra { "build@master.org" }

sourceSets.all { extra["purpose"] = null }

sourceSets {
    main {
        extra["purpose"] = "production"
    }
    test {
        extra["purpose"] = "test"
    }
    create("plugin") {
        extra["purpose"] = "production"
    }
}

tasks.register("printProperties") {
    val springVersion = springVersion
    val emailNotification = emailNotification
    val productionSourceSets = provider {
        sourceSets.matching { it.extra["purpose"] == "production" }.map { it.name }
    }
    doLast {
        println(springVersion)
        println(emailNotification)
        productionSourceSets.get().forEach { println(it) }
    }
}
build.gradle.kts
$ gradle -q printProperties

This example adds two extra properties to the project object via by extra. Additionally, this example adds a
 property named purpose to each source set by setting extra["purpose"] to null. Once added, you can read and set these properties via extra.
Gradle requires special syntax for adding a property so that it can fail fast. For example, this allows Gradle to
 recognize when a script attempts to set a property that does not exist. You can access extra properties anywhere where
  you can access their owning object. This gives extra properties a wider scope than local variables. Subprojects can
   access extra properties on their parent projects.
~For more information about extra properties, see ExtraPropertiesExtension in the API documentation.
https://docs.gradle.org/current/dsl/org.gradle.api.plugins.ExtraPropertiesExtension.html

Configure Arbitrary Objects
<< 'build.gradle.kts'
#The example greet() task shows an example of arbitrary object configuration:
class UserInfo(
    var name: String? = null,
    var email: String? = null
)

tasks.register("greet") {
    val user = UserInfo().apply {
        name = "Isaac Newton"
        email = "isaac@newton.me"
    }
    doLast {
        println(user.name)
        println(user.email)
    }
}
build.gradle.kts
$ gradle -q greet

Closure Delegates
Each closure has a delegate object. Groovy uses this delegate to look up variable and method references to
nonlocal variables and closure parameters. Gradle uses this for configuration closures, where the delegate object refers to
 the object being configured.
<< 'build.gradle.kts'
dependencies {
    assert delegate == project.dependencies
    testImplementation('junit:junit:4.13')
    delegate.testImplementation('junit:junit:4.13')
}
build.gradle.kts

Default imports
To make build scripts more concise, Gradle automatically adds a set of import statements to scripts.
As a result, instead of writing
<< 'build.gradle.kts'
throw new org.gradle.api.tasks.StopExecutionException()
#, you can write
throw new StopExecutionException()
#instead.
build.gradle.kts

https://docs.gradle.org/current/userguide/tutorial_using_tasks.html#tutorial_using_tasks
The work that Gradle can do on a project is defined by one or more tasks.
A task represents some independent unit of work that a build performs. This might be compiling some classes, creating a
 JAR, generating Javadoc, or publishing some archives to a repository.
When a user runs ./gradlew build in the command line, Gradle will execute the build task along with any other tasks it depends on.
Gradle provides several default tasks for a project, which are listed by running
./gradlew tasks

Tasks either come from build scripts or plugins.
Once we apply a plugin to our project, such as the application plugin, additional tasks become available:
<< 'build.gradle.kts'
plugins {
    id("application")
}
build.gradle.kts

Task classification - There are two classes of tasks that can be executed:

Actionable tasks have some actions attached to do work in your build: compileJava.
Lifecycle tasks are tasks with no actions attached: assemble, build.

Typically, a lifecycle tasks depends on many actionable tasks, and is used to execute many tasks at once.

Task registration and action
Let’s take a look at a simple "Hello World" task in a build script:
<< 'build.gradle.kts'
tasks.register("hello") {
    doLast {
        println("Hello world!")
    }
}
build.gradle.kts
In the example, the build script registers a single task called hello using the TaskContainer API, and adds an action to it.
https://docs.gradle.org/current/javadoc/org/gradle/api/tasks/TaskContainer.html
#If the tasks in the project are listed, the hello task is available to Gradle:
$ ./gradlew app:tasks --all
You can execute the task in the build script with ./gradlew hello:
$ ./gradlew hello

Task group and description
The hello task from the previous section can be detailed with a description and assigned to a group with the following update:
<< 'build.gradle.kts'
tasks.register("hello") {
    group = "Custom"
    description = "A lovely greeting task."
    doLast {
        println("Hello world!")
    }
}
build.gradle.kts
To view information about a task, use the help --task <task-name> command:
$./gradlew help --task hello

Task dependencies
You can declare tasks that depend on other tasks:
<< 'build.gradle.kts'
tasks.register("hello") {
    doLast {
        println("Hello world!")
    }
    dependsOn(tasks.assemble)
}
tasks.register("intro") {
    dependsOn("hello")
    doLast {
        println("I'm Gradle")
    }
}
build.gradle.kts
$ gradle -q intro

The dependency of taskX to taskY may be declared before taskY is defined:
<< 'build.gradle.kts'
tasks.register("taskX") {
    dependsOn("taskY")
    doLast {
        println("taskX")
    }
}
tasks.register("taskY") {
    doLast {
        println("taskY")
    }
}
build.gradle.kts
$ gradle -q taskX

Task configuration
Once registered, tasks can be accessed via the TaskProvider API for further configuration.
https://docs.gradle.org/current/javadoc/org/gradle/api/tasks/TaskProvider.html
<< 'build.gradle.kts'
#For instance, you can use this to add dependencies to a task at runtime dynamically:
repeat(4) { counter ->
    tasks.register("task$counter") {
        doLast {
            println("I'm task number $counter")
        }
    }
}
tasks.named("task0") { dependsOn("task2", "task3") }
build.gradle.kts
$ gradle -q task0

You can add behavior to an existing task:
<< 'build.gradle.kts'
tasks.register("hello") {
    doLast {
        println("Hello Earth")
    }
}
tasks.named("hello") {
    doFirst {
        println("Hello Venus")
    }
}
tasks.named("hello") {
    doLast {
        println("Hello Mars")
    }
}
tasks.named("hello") {
    doLast {
        println("Hello Jupiter")
    }
}
#The calls doFirst and doLast can be executed multiple times. They add an action to the beginning or the end of the
# task’s actions list. When the task executes, the actions in the action list are executed in order.
build.gradle.kts
$ gradle -q hello

Here is an example of the named method being used to configure a task added by a plugin:
<< 'build.gradle.kts'
tasks.named("dokkaHtml") {
    outputDirectory.set(buildDir.resolve("dokka"))
}
build.gradle.kts

Task types - Gradle tasks are a subclass of Task.
In the build script, the HelloTask class is created by extending DefaultTask:
<< 'build.gradle.kts'
// Extend the DefaultTask class to create a HelloTask class
abstract class HelloTask : DefaultTask() {
    @TaskAction
    fun hello() {
        println("hello from HelloTask")
    }
}

// Register the hello Task with type HelloTask
tasks.register<HelloTask>("hello") {
    group = "Custom tasks"
    description = "A lovely greeting task."
}
#The hello task is registered with the type HelloTask. Executing our new hello task:
build.gradle.kts
$ ./gradlew hello
Now the hello task is of type HelloTask instead of type Task. The Gradle help task reveals the change:
$ ./gradlew help --task hello

Built-in task types
Gradle provides many built-in task types with common and popular functionality, such as copying or deleting files.
This example task copies *.war files from the source directory to the target directory using the Copy built-in task:
<< 'build.gradle.kts'
tasks.register("copyTask",Copy) {
    from("source")
    into("target")
    include("*.war")
}
build.gradle.kts
There are many task types developers can take advantage of, including GroovyDoc, Zip, Jar, JacocoReport, Sign, or
 Delete, which are available in the DSL.
link:../dsl/org.gradle.api.plugins.antlr.AntlrTask.html

https://docs.gradle.org/current/userguide/writing_tasks.html#writing_tasks
Gradle tasks are created by extending DefaultTask.
However, the generic DefaultTask provides no action for Gradle. If users want to extend the capabilities of Gradle and
 their build script, they must either use a built-in task or create a custom task:

Built-in task - Gradle provides built-in utility tasks such as Copy, Jar, Zip, Delete, etc.,
Custom task - Gradle allows users to subclass DefaultTask to create their own task types.

Create a task
The simplest and quickest way to create a custom task is in a build script:
To create a task, inherit from the DefaultTask class and implement a @TaskAction handler:
<< 'build.gradle.kts'
abstract class CreateFileTask : DefaultTask() {
    @TaskAction
    fun action() {
        val file = File("myfile.txt")
        file.createNewFile()
        file.writeText("HELLO FROM MY TASK")
    }
}
build.gradle.kts
The CreateFileTask implements a simple set of actions. First, a file called "myfile.txt" is created in the
 main project. Then, some text is written to the file.

Register a task
<< 'build.gradle.kts'
#A task is registered in the build script using the TaskContainer.register() method, which allows it
# to be then used in the build logic.
abstract class CreateFileTask : DefaultTask() {
    @TaskAction
    fun action() {
        val file = File("myfile.txt")
        file.createNewFile()
        file.writeText("HELLO FROM MY TASK")
    }
}
tasks.register<CreateFileTask>("createFileTask")
build.gradle.kts

Task group and description
Setting the group and description properties on your tasks can help users understand how to use your task:
<< 'build.gradle.kts'
abstract class CreateFileTask : DefaultTask() {
    @TaskAction
    fun action() {
        val file = File("myfile.txt")
        file.createNewFile()
        file.writeText("HELLO FROM MY TASK")
    }
}
tasks.register<CreateFileTask>("createFileTask", ) {
    group = "custom"
    description = "Create myfile.txt in the current directory"
}
#Once a task is added to a group, it is visible when listing tasks.
build.gradle.kts

Task input and outputs
~For the task to do useful work, it typically needs some inputs. A task typically produces outputs.
<< 'build.gradle.kts'
abstract class CreateFileTask : DefaultTask() {
    @Input
    val fileText = "HELLO FROM MY TASK"

    @Input
    val fileName = "myfile.txt"

    @OutputFile
    val myFile: File = File(fileName)

    @TaskAction
    fun action() {
        myFile.createNewFile()
        myFile.writeText(fileText)
    }
}

tasks.register<CreateFileTask>("createFileTask") {
    group = "custom"
    description = "Create myfile.txt in the current directory"
}
build.gradle.kts

Configure a task
The CreateFileTask class is updated so that the text in the file is configurable:
<< 'build.gradle.kts'
abstract class CreateFileTask : DefaultTask() {
    @get:Input
    abstract val fileText: Property<String>

    @Input
    val fileName = "myfile.txt"

    @OutputFile
    val myFile: File = File(fileName)

    @TaskAction
    fun action() {
        myFile.createNewFile()
        myFile.writeText(fileText.get())
    }
}

tasks.register<CreateFileTask>("createFileTask") {
    group = "custom"
    description = "Create myfile.txt in the current directory"
    fileText.convention("HELLO FROM THE CREATE FILE TASK METHOD") // Set convention
}

#A task is optionally configured in a build script using the TaskCollection.named() method.
tasks.named<CreateFileTask>("createFileTask") {
    fileText.set("HELLO FROM THE NAMED METHOD") // Override with custom message
}
#In the named() method, we find the createFileTask task and set the text that will be written to the file.
build.gradle.kts
When the task is executed:
$ ./gradlew createFileTask
A text file called myfile.txt is created in the project root folder:
myfile.txt
HELLO FROM THE NAMED METHOD
https://docs.gradle.org/current/userguide/more_about_tasks.html#more_about_tasks

https://docs.gradle.org/current/userguide/plugins.html#using_plugins
Much of Gradle’s functionality is delivered via plugins, including core plugins distributed with Gradle,
 third-party plugins, and script plugins defined within builds.
Plugins introduce new tasks \(e.g., JavaCompile\), domain objects \(e.g., SourceSet\), conventions
 \(e.g., locating Java source at src/main/java\), and extend core or other plugin objects.
Plugins in Gradle are essential for automating common build tasks, integrating with external tools or services, and
tailoring the build process to meet specific project needs. They also serve as the primary mechanism for organizing build logic.

Benefits of plugins
Writing many tasks and duplicating configuration blocks in build scripts can get messy. Plugins offer several
 advantages over adding logic directly to the build script:
Promotes Reusability: Reduces the need to duplicate similar logic across projects.
Enhances Modularity: Allows for a more modular and organized build script.
Encapsulates Logic: Keeps imperative logic separate, enabling more declarative build scripts.

Plugin distribution
You can leverage plugins from Gradle and the Gradle community or create your own.
Plugins are available in three ways:
Core plugins - Gradle develops and maintains a set of Core Plugins.
https://docs.gradle.org/current/userguide/plugin_reference.html#plugin_reference
Community plugins - Gradle plugins shared in a remote repository such as Maven or the Gradle Plugin Portal.
#https://plugins.gradle.org/
Local plugins - Gradle enables users to create custom plugins using APIs.
https://docs.gradle.org/current/javadoc/org/gradle/api/Plugin.html

Types of plugins
Plugins can be implemented as binary plugins, precompiled script plugins, or script plugins:
#Binary Plugins
Binary plugins are compiled plugins typically written in Java or Kotlin DSL that are packaged as JAR files. They are
 applied to a project using the plugins {} block. They offer better performance and maintainability compared to
  script plugins or precompiled script plugins.
#Precompiled Script Plugins
Precompiled script plugins are Groovy DSL or Kotlin DSL scripts compiled and distributed as Java class files packaged in a
 library. They are applied to a project using the plugins {} block. They provide a way to reuse complex logic across
  projects and allow for better organization of build logic.
#Script Plugins
Script plugins are Groovy DSL or Kotlin DSL scripts that are applied directly to a Gradle build script using the
apply from: syntax. They are applied inline within a build script to add functionality or
 customize the build process. They are simple to use.
A plugin often starts as a script plugin \(because they are easy to write\). Then, as the code becomes more valuable,
 it’s migrated to a binary plugin that can be easily tested and shared between multiple projects or organizations.

Using plugins
To use the build logic encapsulated in a plugin, Gradle needs to perform two steps. First, it needs to resolve the
 plugin, and then it needs to apply the plugin to the target, usually a Project.
Resolving a plugin means finding the correct version of the JAR that contains a given plugin and adding it to the
script classpath. Once a plugin is resolved, its API can be used in a build script. Script plugins are self-resolving in
 that they are resolved from the specific file path or URL provided when applying them. Core binary plugins provided as
  part of the Gradle distribution are automatically resolved.
Applying a plugin means executing the plugin’s Plugin.apply\(T\) on a project.
https://docs.gradle.org/current/javadoc/org/gradle/api/Plugin.html#apply-T-
The plugins DSL is recommended to resolve and apply plugins in one step.
https://docs.gradle.org/current/userguide/plugins.html#sec:plugins_block

Resolving plugins
Gradle provides the core plugins \(e.g., JavaPlugin, GroovyPlugin, MavenPublishPlugin, etc.\) as part of its
 distribution, which means they are automatically resolved.
Core plugins are applied in a build script using the plugin name:
<< 'build.gradle.kts'
plugins {
    id «plugin name»
}
build.gradle.kts
<< 'build.gradle.kts'
plugins {
    id("java")
}
build.gradle.kts
Non-core plugins must be resolved before they can be applied. Non-core plugins are identified by a unique ID and a version in the build file:
<< 'build.gradle.kts'
plugins {
    id «plugin id» version «plugin version»
}
build.gradle.kts
And the location of the plugin must be specified in the settings file:
<< 'settings.gradle.kts'
pluginManagement {
    repositories {
        gradlePluginPortal()
        maven {
            url 'https://maven.example.com/plugins'
        }
    }
}
settings.gradle.kts
There are additional considerations for resolving and applying plugins:

#	To	Use	For example:
1 Apply a core, community or local plugin to a specific project.
The plugins block in the build file
https://docs.gradle.org/current/userguide/plugins.html#sec:plugins_block
<< 'build.gradle.kts'
plugins {
  id("org.barfuin.gradle.taskinfo") version "2.1.0"
}
build.gradle.kts

2 Apply common core, community or local plugin to multiple subprojects.
A build script in the buildSrc directory
https://docs.gradle.org/current/userguide/plugins.html#sec:buildsrc_plugins_dsl
<< 'build.gradle.kts'
plugins {
    id("org.barfuin.gradle.taskinfo") version "2.1.0"
}
repositories {
    mavenCentral()
}
dependencies {
    implementation(Libs.Kotlin.coroutines)
}
build.gradle.kts

3 Apply a core, community or local plugin needed for the build script itself.
The buildscript block in the build file
https://docs.gradle.org/current/userguide/plugins.html#sec:applying_plugins_buildscript
<< 'build.gradle.kts'
buildscript {
  repositories {
    maven {
      url = uri("https://plugins.gradle.org/m2/")
    }
  }
  dependencies {
    classpath("org.barfuin.gradle.taskinfo:gradle-taskinfo:2.1.0")
  }
}
plugins {
  id("org.barfuin.gradle.taskinfo") version "2.1.0"
}
build.gradle.kts

4 Apply a local script plugins.
https://docs.gradle.org/current/userguide/plugins.html#sec:script_plugins
<< 'build.gradle.kts'
#The legacy apply() method in the build file
apply(plugin = "org.barfuin.gradle.taskinfo")
apply<MyPlugin>()
build.gradle.kts

1. Applying plugins using the plugins{} block
https://docs.gradle.org/current/userguide/plugins.html#sec:plugins_block
The plugin DSL provides a concise and convenient way to declare plugin dependencies.
The plugins block configures an instance of PluginDependenciesSpec:
https://docs.gradle.org/current/javadoc/org/gradle/plugin/use/PluginDependenciesSpec.html
<< 'build.gradle.kts'
plugins {
    application                                     // by name
    java                                            // by name
    id("java")                                      // by id - recommended
    id("org.jetbrains.kotlin.jvm") version "2.0.20"  // by id - recommended
}
build.gradle.kts
Core Gradle plugins are unique in that they provide short names, such as java for the core JavaPlugin.
https://docs.gradle.org/current/javadoc/org/gradle/api/plugins/JavaPlugin.html
To apply a core plugin, the short name can be used:
<< 'build.gradle.kts'
plugins {
    java                                            // by name
}
build.gradle.kts
All other binary plugins must use the fully qualified form of the plugin id \(e.g., com.github.foo.bar\).
To apply a community plugin from Gradle plugin portal, the fully qualified plugin id, a globally unique identifier, must be used:
#http://plugins.gradle.org/
<< 'build.gradle.kts'
plugins {
    id("org.springframework.boot") version "3.3.1"
}
build.gradle.kts
See PluginDependenciesSpec for more information on using the Plugin DSL.
https://docs.gradle.org/current/javadoc/org/gradle/plugin/use/PluginDependenciesSpec.html

The plugins {} block does not support arbitrary code.
It is constrained to be idempotent \(produce the same result every time\) and side effect-free \(safe for
 Gradle to execute at any time\).
<< 'build.gradle.kts'
plugins {
#for core Gradle plugins or plugins already available to the build script
    id(«plugin id»)
#for binary Gradle plugins that need to be resolved
    id(«plugin id») version «plugin version»
}
#Where «plugin id» and «plugin version» are a string.
build.gradle.kts
The plugins{} block must also be a top-level statement in the build script. It cannot be nested inside another
construct \(e.g., an if-statement or for-loop\).
Only in build scripts and settings file
The plugins{} block can only be used in a project’s build script ~build.gradle.kts and the ~settings.gradle.kts file.
 It must appear before any other block. It cannot be used in script plugins or init scripts.

Applying plugins to all subprojects
Suppose you have a multi-project build, you probably want to apply plugins to some or all of the subprojects in
your build but not to the root project.
~While the default behavior of the plugins{} block is to immediately resolve and apply the plugins, you can use the
 apply false syntax to tell Gradle not to apply the plugin to the current project. Then, use the plugins{} block without the
  version in subprojects build scripts:
<< 'settings.gradle.kts'
include("hello-a")
include("hello-b")
include("goodbye-c")
settings.gradle.kts
<< 'build.gradle.kts'
plugins {
    id("com.example.hello") version "1.0.0" apply false
    id("com.example.goodbye") version "1.0.0" apply false
}
build.gradle.kts
<< 'build.gradle.kts'
hello-a/build.gradle.kts
plugins {
    id("com.example.hello")
}
build.gradle.kts
<< 'build.gradle.kts'
hello-b/build.gradle.kts
plugins {
    id("com.example.hello")
}
build.gradle.kts
<< 'build.gradle.kts'
goodbye-c/build.gradle.kts
plugins {
    id("com.example.goodbye")
}
build.gradle.kts
You can also encapsulate the versions of external plugins by composing the build logic using your own convention plugins.
https://docs.gradle.org/current/userguide/sharing_build_logic_between_subprojects.html#sec:convention_plugins

2. Applying plugins from the buildSrc directory
https://docs.gradle.org/current/userguide/plugins.html#sec:buildsrc_plugins_dsl
buildSrc is an optional directory at the Gradle project root that contains build logic \(i.e., plugins\) used in
 building the main project. You can apply plugins that reside in a project’s buildSrc directory as long as they have a defined ID.
The following example shows how to tie the plugin implementation class my.MyPlugin, defined in buildSrc, to the id "my-plugin":
<< 'build.gradle.kts'
plugins {
    `java-gradle-plugin`
}

gradlePlugin {
    plugins {
        create("myPlugins") {
            id = "my-plugin"
            implementationClass = "my.MyPlugin"
        }
    }
}
build.gradle.kts
The plugin can then be applied by ID:
<< 'build.gradle.kts'
plugins {
    id("my-plugin")
}
build.gradle.kts

3. Applying plugins using the buildscript{} block
https://docs.gradle.org/current/userguide/plugins.html#sec:applying_plugins_buildscript
The buildscript block is used for:
global dependencies and repositories required for building the project \(applied in the subprojects\).
declaring which plugins are available for use in the build script \(in the ~build.gradle.kts file itself\).
So when you want to use a library in the build script itself, you must add this library on the script classpath using buildScript:
<< 'build.gradle.kts'
import org.apache.commons.codec.binary.Base64

buildscript {
    repositories {  // this is where the plugins are located
        mavenCentral()
        google()
    }
    dependencies { // these are the plugins that can be used in subprojects or in the build file itself
        classpath group: 'commons-codec', name: 'commons-codec', version: '1.2' // used in the task below
        classpath 'com.android.tools.build:gradle:4.1.0' // used in subproject
    }
}

tasks.register('encode') {
    doLast {
        def byte[] encodedString = new Base64().encode('hello world\n'.getBytes())
        println new String(encodedString)
    }
}
build.gradle.kts
And you can apply the globally declared dependencies in the subproject that needs it:
<< 'build.gradle.kts'
plugins {
    id 'com.android.application'
}
build.gradle.kts

Binary plugins published as external jar files can be added to a project by adding the plugin to the build script classpath and then applying the plugin.
External jars can be added to the build script classpath using the buildscript{} block as described in External dependencies for the build script:
<< 'build.gradle.kts'
buildscript {
    repositories {
        gradlePluginPortal()
    }
    dependencies {
        classpath("org.springframework.boot:spring-boot-gradle-plugin:3.3.1")
    }
}

apply(plugin = "org.springframework.boot")
build.gradle.kts

4. Applying script plugins using the legacy apply\(\) method
https://docs.gradle.org/current/userguide/plugins.html#sec:script_plugins
A script plugin is an ad-hoc plugin, typically written and applied in the same build script. It is applied using the legacy application method:
https://docs.gradle.org/current/userguide/plugins.html#sec:old_plugin_application
<< 'build.gradle.kts'
class MyPlugin : Plugin<Project> {
    override fun apply(project: Project) {
        println("Plugin ${this.javaClass.simpleName} applied on ${project.name}")
    }
}

apply<MyPlugin>()
build.gradle.kts
Lets take a rudimentary example of a plugin written in a file called other.gradle located in the same directory as the build.gradle file:
<< 'other.gradle.kts'
public class Other implements Plugin<Project> {
    @Override
    void apply(Project project) {
        // Does something
    }
}
other.gradle.kts
First, import the external file using:
<< 'build.gradle.kts'
apply from: 'other.gradle'
#Then you can apply it:
apply plugin: Other
build.gradle.kts
Script plugins are automatically resolved and can be applied from a script on the local filesystem or remotely:
<< 'build.gradle.kts'
apply(from = "other.gradle.kts")
build.gradle.kts
Filesystem locations are relative to the project directory, while remote script locations are specified with an HTTP URL.
 Multiple script plugins \(of either form\) can be applied to a given target.

The pluginManagement{} block is used to configure repositories for plugin resolution and to define version constraints for
 plugins that are applied in the build scripts.
The pluginManagement{} block can be used in a ~settings.gradle.kts file, where it must be the first block in the file:
<< 'settings.gradle.kts'
pluginManagement {
    plugins {
    }
    resolutionStrategy {
    }
    repositories {
    }
}
rootProject.name = "plugin-management"
settings.gradle.kts
The block can also be used in Initialization Script:
https://docs.gradle.org/current/userguide/init_scripts.html#init_scripts
<< 'init.gradle.kts'
settingsEvaluated {
    pluginManagement {
        plugins {
        }
        resolutionStrategy {
        }
        repositories {
        }
    }
}
init.gradle.kts

Custom Plugin Repositories
By default, the plugins{} DSL resolves plugins from the public Gradle Plugin Portal.
#https://plugins.gradle.org/
Many build authors would also like to resolve plugins from private Maven or Ivy repositories because they contain
proprietary implementation details or to have more control over what plugins are available to their builds.
To specify custom plugin repositories, use the repositories{} block inside pluginManagement{}:
<< 'settings.gradle.kts'
pluginManagement {
    repositories {
        maven(url = "./maven-repo")
        gradlePluginPortal()
        ivy(url = "./ivy-repo")
    }
}
settings.gradle.kts
This tells Gradle to first look in the Maven repository at ../maven-repo when resolving plugins and then to check the
 Gradle Plugin Portal if the plugins are not found in the Maven repository. If you don’t want the
 Gradle Plugin Portal to be searched, omit the gradlePluginPortal\(\) line. Finally, the
  Ivy repository at ../ivy-repo will be checked.

Plugin Version Management
A plugins{} block inside pluginManagement{} allows all plugin versions for the build to be defined in a single location.
 Plugins can then be applied by id to any build script via the plugins{} block.
One benefit of setting plugin versions this way is that the pluginManagement.plugins{} does not have the
 same constrained syntax as the build script plugins{} block. This allows plugin versions to be taken from
  gradle.properties, or loaded via another mechanism.
Managing plugin versions via pluginManagement:
<< 'settings.gradle.kts'
pluginManagement {
  val helloPluginVersion: String by settings
  plugins {
    id("com.example.hello") version "${helloPluginVersion}"
  }
}
settings.gradle.kts
<< 'build.gradle.kts'
plugins {
    id("com.example.hello")
}
build.gradle.kts
<< 'gradle.properties'
helloPluginVersion=1.0.0
gradle.properties
The plugin version is loaded from gradle.properties and configured in the settings script, allowing the plugin to be
 added to any project without specifying the version.

Plugin Resolution Rules
Plugin resolution rules allow you to modify plugin requests made in plugins{} blocks, e.g., changing the
 requested version or explicitly specifying the implementation artifact coordinates.
To add resolution rules, use the resolutionStrategy{} inside the pluginManagement{} block:
<< 'settings.gradle.kts'
pluginManagement {
    resolutionStrategy {
        eachPlugin {
            if (requested.id.namespace == "com.example") {
                useModule("com.example:sample-plugins:1.0.0")
            }
        }
    }
    repositories {
        maven {
            url = uri("./maven-repo")
        }
        gradlePluginPortal()
        ivy {
            url = uri("./ivy-repo")
        }
    }
}
settings.gradle.kts
This tells Gradle to use the specified plugin implementation artifact instead of its built-in default mapping from
 plugin ID to Maven/Ivy coordinates.
Custom Maven and Ivy plugin repositories must contain plugin marker artifacts and the artifacts that implement the
 plugin. Read Gradle Plugin Development Plugin for more information on publishing plugins to custom repositories.
https://docs.gradle.org/current/userguide/plugins.html#sec:plugin_markers
https://docs.gradle.org/current/userguide/java_gradle_plugin.html#java_gradle_plugin
See PluginManagementSpec for complete documentation for using the pluginManagement{} block.
https://docs.gradle.org/current/javadoc/org/gradle/plugin/management/PluginManagementSpec.html

Plugin Marker Artifacts
Since the plugins{} DSL block only allows for declaring plugins by their globally unique plugin id and version properties,
 Gradle needs a way to look up the coordinates of the plugin implementation artifact.
To do so, Gradle will look for a Plugin Marker Artifact with the coordinates plugin.id:plugin.id.gradle.plugin:plugin.version.
 This marker needs to have a dependency on the actual plugin implementation. Publishing these markers is automated by the java-gradle-plugin.
https://docs.gradle.org/current/userguide/java_gradle_plugin.html#java_gradle_plugin
~For example, the following complete sample from the sample-plugins project shows how to publish a com.example.hello plugin and
 a com.example.goodbye plugin to both an Ivy and Maven repository using the combination of the java-gradle-plugin, the
  maven-publish plugin, and the ivy-publish plugin.
https://docs.gradle.org/current/userguide/publishing_maven.html#publishing_maven
https://docs.gradle.org/current/userguide/publishing_ivy.html#publishing_ivy
<< 'build.gradle.kts'
plugins {
    `java-gradle-plugin`
    `maven-publish`
    `ivy-publish`
}

group = "com.example"
version = "1.0.0"

gradlePlugin {
    plugins {
        create("hello") {
            id = "com.example.hello"
            implementationClass = "com.example.hello.HelloPlugin"
        }
        create("goodbye") {
            id = "com.example.goodbye"
            implementationClass = "com.example.goodbye.GoodbyePlugin"
        }
    }
}

publishing {
    repositories {
        maven {
            url = uri(layout.buildDirectory.dir("maven-repo"))
        }
        ivy {
            url = uri(layout.buildDirectory.dir("ivy-repo"))
        }
    }
}
build.gradle.kts

Using a Version Catalog
When a project uses a version catalog, plugins can be referenced via aliases when applied.
Let’s take a look at a simple Version Catalog:
<< 'libs.versions.toml'
gradle/libs.versions.toml
[versions]
kotlin = "2.0.20"

[plugins]
kotlin-jvm = {id="org.jetbrains.kotlin.jvm", version.ref="kotlin"}
libs.versions.toml
<< 'build.gradle.kts'
plugins {
    alias(libs.plugins.kotlin.jvm)
}
#kotlin-jvm is available as the Gradle generated safe accessor: kotlin.jvm
build.gradle.kts

https://docs.gradle.org/current/userguide/writing_plugins.html#writing_plugins
Custom plugin
A plugin is any class that implements the Plugin interface.
https://docs.gradle.org/current/javadoc/org/gradle/api/Plugin.html
To create a "hello world" plugin:
	Extend the org.gradle.api.Plugin interface.
  Override the apply method.
<< 'build.gradle.kts'
import org.gradle.api.Plugin
import org.gradle.api.Project

abstract class SamplePlugin : Plugin<Project> {
    override fun apply(project: Project) {
        project.tasks.create("SampleTask") {
            println("Hello world!")
        }
    }
}
build.gradle.kts
Note that this is a simple hello-world example and does not reflect best practices.
Script plugins are not recommended. Plugin code should not be in your ~build.gradle.kts file.
Plugins should always be written as pre-compiled script plugins, convention plugins or binary plugins.

Pre-compiled script plugin
Pre-compiled script plugins offer an easy way to rapidly prototype and experiment. They let you package build logic as
 *.gradle.kts script files using the Groovy or Kotlin DSL. These scripts reside in specific directories,
 such as src/main/groovy or src/main/kotlin.
To apply one, simply use its ID derived from the script filename \(without .gradle\). You can think of the file itself as
 the plugin, so you do not need to subclass the Plugin interface in a precompiled script.
Lets take a look at an example with the following structure:

└── buildSrc
    ├── build.gradle.kts
    └── src
       └── main
          └── kotlin
             └── my-create-file-plugin.gradle.kts

Our my-create-file-plugin.gradle.kts file contains the following code:

<< 'my-create-file-plugin.gradle.kts'
buildSrc/src/main/kotlin/my-create-file-plugin.gradle.kts
abstract class CreateFileTask : DefaultTask() {
    @get:Input
    abstract val fileText: Property<String>

    @Input
    val fileName = "myfile.txt"

    @OutputFile
    val myFile: File = File(fileName)

    @TaskAction
    fun action() {
        myFile.createNewFile()
        myFile.writeText(fileText.get())
    }
}

tasks.register("createFileTask", CreateFileTask::class) {
    group = "from my plugin"
    description = "Create myfile.txt in the current directory"
    fileText.set("HELLO FROM MY PLUGIN")
}
my-create-file-plugin.gradle.kts
<< 'build.gradle.kts'
buildSrc/build.gradle.kts
plugins {
    `kotlin-dsl`
}
build.gradle.kts
The pre-compiled script can now be applied in the ~build.gradle.kts file of any subproject:
<< 'build.gradle.kts'
plugins {
    id("my-create-file-plugin")  // Apply the plugin
}
build.gradle.kts
The createFileTask task from the plugin is now available in your subproject.

Convention Plugins
Convention plugins are a way to encapsulate and reuse common build logic in Gradle. They allow you to define a set of
 conventions for a project, and then apply those conventions to other projects or modules.
The example above has been re-written as a convention plugin as a Kotlin script called MyConventionPlugin.kt and stored in buildSrc:
<< 'buildSrc/src/main/kotlin/MyConventionPlugin.kt'
import org.gradle.api.DefaultTask
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.api.provider.Property
import org.gradle.api.tasks.Input
import org.gradle.api.tasks.OutputFile
import org.gradle.api.tasks.TaskAction
import java.io.File

abstract class CreateFileTask : DefaultTask() {
    @get:Input
    abstract val fileText: Property<String>

    @Input
    val fileName = project.rootDir.toString() + "/myfile.txt"

    @OutputFile
    val myFile: File = File(fileName)

    @TaskAction
    fun action() {
        myFile.createNewFile()
        myFile.writeText(fileText.get())
    }
}

class MyConventionPlugin : Plugin<Project> {
    override fun apply(project: Project) {
        project.tasks.register("createFileTask", CreateFileTask::class.java) {
            group = "from my plugin"
            description = "Create myfile.txt in the current directory"
            fileText.set("HELLO FROM MY PLUGIN")
        }
    }
}
buildSrc/src/main/kotlin/MyConventionPlugin.kt
The plugin can be given an id using a gradlePlugin{} block so that it can be referenced in the root:
<< 'buildSrc/build.gradle.kts'
gradlePlugin {
    plugins {
        create("my-convention-plugin") {
            id = "my-convention-plugin"
            implementationClass = "MyConventionPlugin"
        }
    }
}
buildSrc/build.gradle.kts
The gradlePlugin{} block defines the plugins being built by the project. With the newly created id, the plugin can be
 applied in other build scripts accordingly:
<< 'build.gradle.kts'
plugins {
    application
    id("my-convention-plugin") // Apply the plugin
}
build.gradle.kts

Binary Plugins
A binary plugin is a plugin that is implemented in a compiled language and is packaged as a JAR file. It is resolved as
 a dependency rather than compiled from source.
~For most use cases, convention plugins must be updated infrequently. Having each developer execute the plugin build as
 part of their development process is wasteful, and we can instead distribute them as binary dependencies.
There are two ways to update the convention plugin in the example above into a binary plugin.
Use composite builds:
<< 'settings.gradle.kts'
includeBuild("my-plugin")
settings.gradle.kts
Publish the plugin to a repository:
<< 'build.gradle.kts'
plugins {
    id("com.gradle.plugin.myconventionplugin") version "1.0.0"
}
build.gradle.kts
Consult the Developing Plugins chapter to learn more.
https://docs.gradle.org/current/userguide/custom_plugins.html#custom_plugins

https://docs.gradle.org/current/userguide/partr1_gradle_init.html
