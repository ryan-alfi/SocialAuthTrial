//
//  PasswordRecoveryOtpRequestModel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 27/11/23.
//

struct PasswordRecoveryOtpRequestModel {
    let sessionId: String
    let otp: String
    let identity: String
    let identityType: String
    let newPassword: String
    
    func toDictionary() -> [String: Any] {
        return [
            "session_id": sessionId,
            "otp": otp,
            "identity": identity,
            "identity_type": identityType,
            "new_password": newPassword
        ]
    }
}
