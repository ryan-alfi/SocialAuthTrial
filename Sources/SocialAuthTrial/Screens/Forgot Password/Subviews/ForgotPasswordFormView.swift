//
//  ForgotPasswordFormView.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/10/23.
//

import UIKit

final class ForgotPasswordFormView: RegisterFormView {
    
    override func tapRightButton() {
        super.tapRightButton()
        resetUI()
        otpView.title = "Enter OTP"
    }
    
}
