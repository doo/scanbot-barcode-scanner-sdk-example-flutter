# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html
# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}
# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable
# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontpreverify
-dontshrink
-verbose
-ignorewarnings

-keeppackagenames io.scanbot.barcodescanner.**
-keep public class io.scanbot.barcodescanner.**{ *; }

-keeppackagenames io.scanbot.sdk.barcode.**
-keep public class io.scanbot.sdk.barcode.** { *; }

-keeppackagenames io.scanbot.sdk.barcode_scanner.**
-keep public class io.scanbot.sdk.barcode_scanner.** { *; }

-keeppackagenames io.scanbot.sdk.flutter.**
-keep public class io.scanbot.sdk.flutter.**{ *; }

-keeppackagenames io.scanbot.sap.**
-keep public class io.scanbot.sap.** { *; }

-keepclassmembers enum io.scanbot.** {*;}
-keepclassmembers class io.scanbot.** extends java.lang.Enum {
    <fields>;
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# JSR 305 annotations are for embedding nullability information.
-dontwarn javax.annotation.**
-dontwarn org.jetbrains.annotations.**

-keepnames class kotlin.jvm.internal.DefaultConstructorMarker
-keep public class kotlin.reflect.jvm.internal.impl.** { public *; }
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

##---------------Begin: proguard configuration for Gson  ----------
# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
-dontwarn sun.misc.**
-keep class com.google.gson.stream.** { *; }

# Application classes that will be serialized/deserialized over Gson
-keep class com.google.gson.examples.android.model.** { <fields>; }

# Prevent proguard from stripping interface information from TypeAdapter, TypeAdapterFactory,
# JsonSerializer, JsonDeserializer instances (so they can be used in @JsonAdapter)
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken

##---------------End: proguard configuration for Gson  ----------