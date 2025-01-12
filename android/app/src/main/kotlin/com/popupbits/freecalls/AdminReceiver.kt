package com.popupbits.freecalls

import android.app.admin.DeviceAdminReceiver
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log

class AdminReceiver : DeviceAdminReceiver() {
 companion object {
    fun getComponentName(context: Context): ComponentName {
      return ComponentName(context.applicationContext, AdminReceiver::class.java)
    }

    private val TAG = AdminReceiver::class.java.simpleName
  }

  override fun onLockTaskModeEntering(context: Context, intent: Intent, pkg: String) {
    super.onLockTaskModeEntering(context, intent, pkg)
    Log.d(TAG, "onLockTaskModeEntering")
  }

  override fun onLockTaskModeExiting(context: Context, intent: Intent) {
    super.onLockTaskModeExiting(context, intent)
    Log.d(TAG, "onLockTaskModeExiting")
  }
}