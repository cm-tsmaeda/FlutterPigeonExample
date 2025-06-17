package com.example.pigeon_example

import PgnAppLifecycleState
import android.util.Log
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner

interface AppLifecycleStateChangeCallback {
    fun onLifecycleStateChanged(state: PgnAppLifecycleState)
}

class AppLifecycleObserver(val stateChangeCallback: AppLifecycleStateChangeCallback?) : DefaultLifecycleObserver {

    private var isFirstStart: Boolean = true

    override fun onStart(owner: LifecycleOwner) {
        super.onStart(owner)
        Log.d("ProcessLifecycle", "🟢 アプリがフォアグラウンドに移行")
        if (isFirstStart) {
            isFirstStart = false
            return
        }
        stateChangeCallback?.onLifecycleStateChanged(PgnAppLifecycleState.ENTER_FOREGROUND)
    }

    override fun onStop(owner: LifecycleOwner) {
        super.onStop(owner)
        Log.d("ProcessLifecycle", "🔴 アプリがバックグラウンドに移行")
        stateChangeCallback?.onLifecycleStateChanged(PgnAppLifecycleState.ENTER_BACKGROUND)
    }

    override fun onResume(owner: LifecycleOwner) {
        super.onResume(owner)
        Log.d("ProcessLifecycle", "🟡 アプリが完全にアクティブ")
    }

    override fun onPause(owner: LifecycleOwner) {
        super.onPause(owner)
        Log.d("ProcessLifecycle", "🟠 アプリが一時停止")
    }

    override fun onCreate(owner: LifecycleOwner) {
        super.onCreate(owner)
        Log.d("ProcessLifecycle", "🟢 プロセス作成")
    }

    override fun onDestroy(owner: LifecycleOwner) {
        super.onDestroy(owner)
        Log.d("ProcessLifecycle", "💀 プロセス破棄")
    }
}