//
//  PgnGreetingHostApiImpl.swift
//  Runner
//
//  Created by Tasuku Maeda on 2025/06/16.
//

class PgnGreetingHostApiImpl: PgnGreetingHostApi {
    
    /// ホスト側の言語を取得する
    func getHostLanguage() throws -> String {
        // エラーを返す例
        // throw PigeonError(code: "100", message: "まだ実装していません", details: nil)
        
        // 正常系
        "Swift"
    }
    
    /// あいさつのメッセージを取得する
    /// [person] あいさつ対象の人
    ///
    /// Returns: あいさつのメッセージ
    func getMessage(person: PgnPerson, completion: @escaping (Result<String, Error>) -> Void) {
        Task.detached {
            try await Task.sleep(for: .seconds(1))
            
            // エラーを返す例
//            await MainActor.run {
//                completion(.failure(
//                    PigeonError(code: "200", message: "何らかのエラー", details: nil)
//                ))
//            }
            
            // 正常系
            await MainActor.run {
                var message = "こんにちは！ \(person.name ?? "ななし") さん。"
                if let age = person.age {
                    message += "\nあなたは \(age)歳ですね!"
                }
                completion(.success(message))
            }
        }
    }
}
