//
//  ErrorModel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 08/11/23.
//

struct ErrorModel: Codable, Equatable {
    var statusCode: Int = -1
    let code: String?
    let messageTitle: String?
    let message: String?
    let messageSeverity: String?
    let action: NextActionResponseModel?
    
    var nextState: String? {
        return action?.nextState
    }
    
    enum CodingKeys: String, CodingKey {
        case code, message, action
        case messageTitle = "message_title"
        case messageSeverity = "message_severity"
    }
}

enum ErrorCode: String {
    case errGeoBlock = "err_geo_block"
    case errEmailUnverified = "err_email_unverified"
    case errPhoneUnverified = "err_phone_unverified"
    case errEmailRegistered = "err_email_registered"
    case errEmailOrPassword = "err_email_or_password"
    case errEmailUnregistered = "err_email_unregistered"
    case errPhoneUnregistered = "err_phone_unregistered"
    case errPhoneRegistered = "err_phone_registered"
    case errEmailRegisteredByExternalProvider = "err_email_registered_by_external_provider"
    case alreadyVerified = "already_verified"
    case notRegistered = "not_registered"
    case errInvalidOtp = "err_invalid_otp"
    case errExpiredOtp = "err_expired_otp"
    case errOtpWaitingTime = "err_otp_waiting_time"
    case errQuotaExceded = "err_quota_exceded"
    case errInternalServer = "err_internal_server"
}
