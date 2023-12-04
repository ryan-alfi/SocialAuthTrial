//
//  AppConstants.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 26/10/23.
//

import UIKit

struct AppConstants {
    
    // TODO: Replace this later with real value clientID
    static var clientID = "visionplus_dev"
    
    static var code = "code"
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    static var isMobile: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static var isTablet: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var insetX: CGFloat {
        return isTablet ? (screenWidth / 4) : 20
    }
}
