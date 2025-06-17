import Flutter
import UIKit
import OSLog

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var appLifecycleFlutterApi: PgnAppLifecycleFlutterApi?
    private var hasEnteredForeground: Bool = false
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        guard let viewController: FlutterViewController = window?.rootViewController as? FlutterViewController else {
            return false
        }
        PgnGreetingHostApiSetup.setUp(
            binaryMessenger: viewController.binaryMessenger,
            api: PgnGreetingHostApiImpl()
        )
        
        appLifecycleFlutterApi = PgnAppLifecycleFlutterApi(binaryMessenger: viewController.binaryMessenger)
          
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func getFlutterLanguage() {
        appLifecycleFlutterApi?.getFlutterLanguage() { result in
            switch result {
            case .success(let language):
                os_log("language: \(language)")
            case .failure(let error):
                os_log("error: \(error.localizedDescription)")
            }
        }
    }
    
    func onAppLifecycleStateChanged(state: PgnAppLifecycleState) {
        appLifecycleFlutterApi?.onAppLifecycleStateChanged(state: state) { result in
            switch result {
            case .success(_):
                os_log("success")
            case .failure(let error):
                os_log("error: \(error.localizedDescription)")
            }
        }
    }
    
    override func applicationWillEnterForeground(_ application: UIApplication) {
        hasEnteredForeground = true
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        
        // applicationDidBecomeActiveはUIAlert表示時にも呼ばれるのでその対策
        if hasEnteredForeground {
            
            // 動くかテスト
            getFlutterLanguage()
            
            // ライフサイクルの状態を送信
            onAppLifecycleStateChanged(state: .enterForeground)
            
            hasEnteredForeground = false
        }
    }
    
    override func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        // ライフサイクルの状態を送信
        onAppLifecycleStateChanged(state: .enterBackground)
    }
}
