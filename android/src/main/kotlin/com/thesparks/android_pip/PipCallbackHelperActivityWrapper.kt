package com.thesparks.android_pip

import android.content.res.Configuration
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine


open class PipCallbackHelperActivityWrapper: FlutterActivity() {
  private var callbackHelper = PipCallbackHelper()

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    callbackHelper.configureFlutterEngine(flutterEngine)
  }

  override fun onPictureInPictureModeChanged(active: Boolean, newConfig: Configuration?) {
    super.onPictureInPictureModeChanged(active, newConfig)
    callbackHelper.onPictureInPictureModeChanged(active)
  }
}