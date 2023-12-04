//
//  VPAuthDelegate.swift
//  VisionPlusBSS
//
//  Created by ERWINDO SIANIPAR on 20/10/2023.
//

public protocol VPAuthDelegate: AnyObject {
    func didAuthenticationSuccess(token: String, provider: VPAuthProvider)
    func didAuthenticationFailure(error: Error)
}
