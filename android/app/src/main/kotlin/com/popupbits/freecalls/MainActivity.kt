package com.popupbits.freecalls

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode.transparent

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.ComponentName
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.app.admin.DevicePolicyManager


class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        intent.putExtra("background_mode", transparent.toString())
        super.onCreate(savedInstanceState)
    }

      private val kioskModeChannel = "kioskModeLocked"
  private lateinit var mAdminComponentName: ComponentName
  private lateinit var mDevicePolicyManager: DevicePolicyManager

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, kioskModeChannel).setMethodCallHandler {
        call, result ->
        if (call.method == "startKioskMode") {
          try {
            manageKioskMode(true)
          } catch (e: Exception) {}
        } else if (call.method == "stopKioskMode") {
          try {
            manageKioskMode(false)
          } catch (e: Exception) {}
        } else {
          result.notImplemented()
        }
      }
  }

  private fun manageKioskMode(enable: Boolean) {
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
        mDevicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        mAdminComponentName = AdminReceiver.getComponentName(this)
        mDevicePolicyManager.setLockTaskPackages(mAdminComponentName, arrayOf(packageName))
        if(enable) {
          this.startLockTask()
        } else {
          this.stopLockTask()
        }
      return
    }
  }
    
}



