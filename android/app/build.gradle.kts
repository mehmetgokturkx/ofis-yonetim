plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    android {
    namespace = "com.example.ofis_yonetim"
    // compileSdk değerini 34 yerine tam olarak 36 yapıyoruz
    compileSdk = 36 
    
    // Sistemimizin istediği güncel NDK sürümünü buraya ekliyoruz
    ndkVersion = "28.2.13676358"

    defaultConfig {
        applicationId = "com.example.ofis_yonetim"
        minSdk = flutter.minSdkVersion // Burası mutedil sınırımız olarak kalıyor (Android 6.0+)
        // targetSdk değerini de en güncel standart olan 36'ya çekiyoruz
        targetSdk = 36 
        versionCode = 1
        versionName = "1.0"
    }
}

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
