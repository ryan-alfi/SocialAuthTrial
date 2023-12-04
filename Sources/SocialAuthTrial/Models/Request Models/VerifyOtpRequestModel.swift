//
//  VerifyOtpRequestModel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 13/11/23.
//

struct VerifyOtpRequestModel {
    let otpSessionId: String
    let otp: String
    let identity: String
    
    func toDictionary() -> [String: Any] {
        return [
            "otp_session_id": otpSessionId,
            "otp": otp,
            "identity": identity
        ]
    }
}
