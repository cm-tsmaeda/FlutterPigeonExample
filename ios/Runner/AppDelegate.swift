import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
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
          
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
