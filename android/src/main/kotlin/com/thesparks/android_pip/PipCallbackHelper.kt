package com.thesparks.android_pip

import androidx.annotation.NonNull
import androidx.lifecycle.Lifecycle
import com.thesparks.android_pip.actions.PIPDefaultEvent
import com.thesparks.android_pip.actions.PipAction
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine


open class PipCallbackHelper {
  private val CHANNEL = "thesparks.android_pip"
  private lateinit var channel: MethodChannel

  fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
  }

  fun setChannel(channel: MethodChannel) {
    this.channel = channel
  }

  fun onPictureInPictureModeChanged(isInPictureInPictureMode: Boolean ,activity: FlutterFragmentActivity) {
    when (activity.lifecycle.currentState) {
      Lifecycle.State.CREATED -> {
        //when user click on Close button of PIP this will trigger, do what you want here
        callbackHelper(PIPDefaultEvent.PIPClosed);
      }

      Lifecycle.State.STARTED -> {
        if (isInPictureInPictureMode) {
          //when PIP maximize this will trigger
          callbackHelper(PIPDefaultEvent.PIPEntered)
        } else {
          callbackHelper(PIPDefaultEvent.PIPMaximised)
        }
      }

      else -> {

      }
    }
  }

  private fun callbackHelper(event: PIPDefaultEvent) {
    when (event) {
        PIPDefaultEvent.PIPEntered -> {
          channel.invokeMethod("onPipEntered", null)
        }
        PIPDefaultEvent.PIPMaximised -> {
          channel.invokeMethod("onPipMaximised", null)
        }
        else -> {
          channel.invokeMethod("onPipExited", null)
        }
    }
  }

  fun onPipAction(action: PipAction) {
    channel.invokeMethod("onPipAction", action.name.lowercase())
  }
}