plugins {
    alias(libs.plugins.android.application)

    // Add the Google services Gradle plugin
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.chatbasicoprojecto"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.chatbasicoprojecto"
        minSdk = 25
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    buildFeatures {
        viewBinding = true
    }
}

dependencies {
    // Import the BoM for the Firebase platform
    implementation(platform(libs.firebase.bom))

    // Add the dependency for the Realtime Database library
    // When using the BoM, you don't specify versions in Firebase library dependencies
    implementation(libs.firebase.database)
    // Add the dependency for storage library and image glide.
    implementation("com.google.firebase:firebase-storage")
    implementation ("com.github.bumptech.glide:glide:4.12.0")
    implementation(libs.firebase.firestore)
    annotationProcessor("com.github.bumptech.glide:compiler:4.12.0")
    //Add the dependency for cloud messaging
    implementation ("com.google.firebase:firebase-messaging:23.4.0")
    implementation ("com.google.firebase:firebase-firestore")
    implementation ("com.android.volley:volley:1.2.1")
    implementation ("com.google.firebase:firebase-database:20.3.0")
//    implementation ("com.google.firebase:firebase-admin:9.2.0")

    implementation ("com.squareup.okhttp3:okhttp:4.9.3")
    //Add the dependency for the activity
    implementation(libs.appcompat)
    implementation(libs.material)
    implementation(libs.activity)
    implementation(libs.constraintlayout)
    implementation(libs.annotation)
    implementation(libs.lifecycle.livedata.ktx)
    implementation(libs.lifecycle.viewmodel.ktx)
    implementation(libs.firebase.auth)
    testImplementation(libs.junit)
    androidTestImplementation(libs.ext.junit)
    androidTestImplementation(libs.espresso.core)
}