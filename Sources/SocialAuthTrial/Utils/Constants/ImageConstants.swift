//
//  ImageConstants.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 16/10/23.
//

import UIKit

private class BundleToken {}

extension Bundle {
    
    static func vpFrameworkBundle() -> Bundle {
        let bundle = Bundle(for: BundleToken.self)
        if let path = bundle.path(forResource: "VisionPlusBSS", ofType: "bundle") {
            return Bundle(path: path) ?? bundle
        } else {
            return bundle
        }
    }
    
}

extension UIImage {
    
    static let icAppleId = image(named: "ic_apple_id")
    static let icFacebook = image(named: "ic_facebook")
    static let icGoogle = image(named: "ic_google")
    static let icArrowLeft = image(named: "ic_arrow_left")
    static let icVisibilityOn = image(named: "ic_visibility_on")
    static let icVisibilityOff = image(named: "ic_visibility_off")
    static let icArrowDown = image(named: "ic_arrow_down")
    static let icFlagId = image(named: "ic_flag_id")
    static let icFlagMy = image(named: "ic_flag_my")
    static let icClose = image(named: "ic_close")
    static let icSearch = image(named: "ic_search")
    static let icInternetOff = image(named: "ic_internet_off")
    
    static let illSuccess = image(named: "ill_success")
    static let illServerError = image(named: "ill_server_error")
    
    fileprivate static func image(named: String) -> UIImage? {
        return UIImage(named: named, in: Bundle.vpFrameworkBundle(), compatibleWith: nil)
    }
}
