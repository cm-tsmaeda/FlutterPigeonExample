package com.example.pigeon_example

import PgnAppLifecycleFlutterApi
import PgnAppLifecycleState
import PgnGreetingHostApi
import android.os.Bundle
import android.util.Log
import androidx.lifecycle.ProcessLifecycleOwner
import com.example.pigeon_example.pigeons.PgnGreetingHostApiImpl
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val greetingHostApi = PgnGreetingHostApiImpl()
        PgnGreetingHostApi.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            greetingHostApi
        )
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val lifecycleObserver = AppLifecycleObserver(object : AppLifecycleStateChangeCallback {
            override fun onLifecycleStateChanged(state: PgnAppLifecycleState) {
                val binaryMessanger = flutterEngine?.dartExecutor?.binaryMessenger ?: return
                val pgnAppLifecycleFlutterApi = PgnAppLifecycleFlutterApi(binaryMessanger)

                // うまく動くかのテスト
                pgnAppLifecycleFlutterApi.getFlutterLanguage { result ->
                    if (result.isSuccess) {
                        val language = result.getOrNull()
                        // 取得した言語を使用して何か処理を行う
                        Log.d("MainActivity", "Flutterの言語: $language")
                    } else {
                        // エラー処理
                        Log.d("MainActivity", "Flutterの言語取得エラー: ${result.exceptionOrNull()?.message}")
                    }
                }

                // Flutter側にアプリの状態を通知
                pgnAppLifecycleFlutterApi.onAppLifecycleStateChanged(state) { result ->
                    if (result.isSuccess) {
                        // 成功時の処理
                        Log.d("MainActivity", "Flutterにアプリの状態を通知しました: $state")
                    } else {
                        // エラー処理
                        Log.d("MainActivity", "Flutterへのアプリ状態通知エラー: ${result.exceptionOrNull()?.message}")
                    }
                }
            }
        })
        ProcessLifecycleOwner.get().lifecycle.addObserver(lifecycleObserver)
    }
}
