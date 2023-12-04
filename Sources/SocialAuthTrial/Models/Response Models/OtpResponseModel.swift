//
//  OtpResponseModel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 13/11/23.
//

struct OtpResponseModel: Codable, Equatable {
    let nextRetryInSecond: Int
    let otpSessionId: String
    
    enum CodingKeys: String, CodingKey {
        case otpSessionId = "otp_session_id"
        case nextRetryInSecond = "next_retry_in_second"
    }
}
