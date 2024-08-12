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
        when (lifecycle.currentState) {
            Lifecycle.State.CREATED -> {
                //when user click on Close button of PIP this will trigger, do what you want here
                callbackHelper.onPictureInPictureModeChanged(PIPDefaultEvent.PIPClosed);
            }

            Lifecycle.State.STARTED -> {
                if (isInPictureInPictureMode) {
                    //when PIP maximize this will trigger
                    callbackHelper.onPictureInPictureModeChanged(PIPDefaultEvent.PIPEntered)
                } else {
                    callbackHelper.onPictureInPictureModeChanged(PIPDefaultEvent.PIPMaximised)
                }
            }

            else -> {

            }
        }
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig);
    }
}