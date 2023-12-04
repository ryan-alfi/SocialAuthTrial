//
//  AppleProvider.swift
//  VisionPlusBSS
//
//  Created by ERWINDO SIANIPAR on 20/10/2023.
//

import UIKit
import AuthenticationServices

class AppleProvider: NSObject, VPAuthProtocol {
    
    static let shared = AppleProvider()
    
    weak var delegate: VPAuthDelegate?
    
    func signIn(controller: UIViewController?) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func signOut() {
        
    }
}

extension AppleProvider: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let identityToken = credential.identityToken, let token = String(data: identityToken, encoding: .utf8) {
                self.delegate?.didAuthenticationSuccess(token: token, provider: .apple)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // https://developer.apple.com/documentation/authenticationservices/asauthorizationerror/code/canceled
        if (error as NSError).code != 1001 {
            self.delegate?.didAuthenticationFailure(error: error)
        }
    }
}

extension AppleProvider: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIWindow(frame: UIScreen.main.bounds)
    }
}
