package com.thesparks.android_pip

import android.content.res.Configuration
import androidx.annotation.NonNull
import androidx.lifecycle.Lifecycle
import com.thesparks.android_pip.actions.PIPDefaultEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine


open class PipCallbackHelperActivityWrapper : FlutterActivity() {
    private var callbackHelper = PipCallbackHelper()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        callbackHelper.configureFlutterEngine(flutterEngine)
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration?
    ) {
        callbackHelper.onPictureInPictureModeChanged(isInPictureInPictureMode,this)
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig);
    }
}