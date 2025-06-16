package com.example.pigeon_example.pigeons

import FlutterError
import PgnGreetingHostApi
import PgnPerson
import kotlinx.coroutines.*

class PgnGreetingHostApiImpl : PgnGreetingHostApi {
    override fun getHostLanguage(): String {
        // エラーを返す例
        //throw FlutterError("101", "まだ実装していません", null)

        // 正常系
        return "Kotlin"
    }

    override fun getMessage(person: PgnPerson, callback: (Result<String>) -> Unit) {
        CoroutineScope(Dispatchers.IO).launch {
            delay(1000)

            // エラーを返す例
//            withContext(Dispatchers.Main) {
//                callback(Result.failure(FlutterError("201", "何らかのエラー", null)))
//            }

            // 正常系
            var message = "こんにちは！ ${person.name ?: "ななし"} さん。"
            person.age?.let { age ->
                message += "\nあなたは ${age}歳ですね!"
            }
            withContext(Dispatchers.Main) {
                // メインスレッドでコールバックを呼び出す
                callback(Result.success(message))
            }
        }
    }
}