package io.scanbot.scanbot_barcode_sdk_example

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication


class Application : FlutterApplication() {

    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }

}