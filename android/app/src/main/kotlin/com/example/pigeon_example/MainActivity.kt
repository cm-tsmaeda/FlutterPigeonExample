package com.example.pigeon_example

import PgnGreetingHostApi
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
}
