//
//  PasswordRecoveryOtpResponseModel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 27/11/23.
//

struct PasswordRecoveryOtpResponseModel: Codable, Equatable {
    let nextRetryInSecond: Int
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case nextRetryInSecond = "next_retry_in_second"
    }
}
