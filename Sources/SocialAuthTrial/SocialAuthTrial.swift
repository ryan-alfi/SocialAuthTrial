import UIKit
@_implementationOnly import FBSDKLoginKit

public struct SocialAuthTrial {
    public static let shared = SocialAuthTrial()
    
    public weak var authDelegate: VPAuthDelegate?
    
    public var localize: String = "en"
    public var key: String?
}

extension SocialAuthTrial {
    
    public func loginViewController() -> UIViewController {
        return LoginViewController.build(delegate: authDelegate)
    }
    
    public func presentLoginScreen(_ vc: UIViewController, animated: Bool = true) {
        let nvc = UINavigationController(rootViewController: loginViewController())
        nvc.modalPresentationStyle = .fullScreen
        vc.present(nvc, animated: animated)
    }
    
    public func pushLoginScreen(_ navigation: UINavigationController?, animated: Bool = true) {
        navigation?.pushViewController(LoginViewController.build(delegate: authDelegate), animated: animated)
    }
    
    public func registerViewController() -> UIViewController {
        return RegisterViewController.build()
    }
    
    public func presentRegisterScreen(_ vc: UIViewController, animated: Bool = true) {
        let nvc = UINavigationController(rootViewController: registerViewController())
        nvc.modalPresentationStyle = .fullScreen
        vc.present(nvc, animated: animated)
    }
    
    public func pushRegisterScreen(_ navigation: UINavigationController?, animated: Bool = true) {
        navigation?.pushViewController(registerViewController(), animated: animated)
    }
    
    public func verifyLinkViewController(sessionId: String, identity: String) -> UIViewController {
        return VerifyLinkViewController.build(sessionId: sessionId, identity: identity)
    }
    
    public func presentVerifyLinkScreen(_ vc: UIViewController, animated: Bool = true, sessionId: String, identity: String) {
        let nvc = UINavigationController(rootViewController: verifyLinkViewController(sessionId: sessionId, identity: identity))
        nvc.modalPresentationStyle = .fullScreen
        vc.present(nvc, animated: animated)
    }
    
    public func pushVerifyLinkScreen(_ navigation: UINavigationController?, animated: Bool = true, sessionId: String, identity: String) {
        navigation?.pushViewController(verifyLinkViewController(sessionId: sessionId, identity: identity), animated: animated)
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
}
