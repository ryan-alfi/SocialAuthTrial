//
//  GoogleProvider.swift
//  VisionPlusBSS
//
//  Created by ERWINDO SIANIPAR on 20/10/2023.
//

@_implementationOnly import GoogleSignIn

class GoogleProvider: VPAuthProtocol {
    
    static let shared = GoogleProvider()
    
    weak var delegate: VPAuthDelegate?
    
    func signIn(controller: UIViewController?) {
        if let controller = controller {
            GIDSignIn.sharedInstance.signIn(withPresenting: controller) { result, error in
                // https://developers.google.com/identity/sign-in/ios/reference/Enums/GIDSignInErrorCode
                if let error = error, (error as NSError).code != -5 {
                    self.delegate?.didAuthenticationFailure(error: error)
                } else if let token = result?.user.idToken?.tokenString {
                    self.delegate?.didAuthenticationSuccess(token: token, provider: .google)
                }
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
