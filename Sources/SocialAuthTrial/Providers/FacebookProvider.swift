//
//  FacebookProvider.swift
//  VisionPlusBSS
//
//  Created by ERWINDO SIANIPAR on 20/10/2023.
//

@_implementationOnly import FBSDKLoginKit

class FacebookProvider: VPAuthProtocol {
    
    static let shared = FacebookProvider()
    
    weak var delegate: VPAuthDelegate?
    
    let manager = LoginManager()
    
    func signIn(controller: UIViewController?) {
        if let controller = controller {
            manager.logIn(permissions: ["public_profile", "email"], from: controller) { result, error in
                if let error = error {
                    self.delegate?.didAuthenticationFailure(error: error)
                } else if let result = result, !result.isCancelled, let token = AccessToken.current?.tokenString {
                    self.delegate?.didAuthenticationSuccess(token: token, provider: .facebook)
                }
            }
        }
    }
    
    func signOut() {
        manager.logOut()
    }
}
