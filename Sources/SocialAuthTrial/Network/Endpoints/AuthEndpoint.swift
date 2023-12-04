//
//  AuthEndpoint.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 08/11/23.
//

struct AuthEndpoint {
    
    static func register(param: RegisterRequestModel) -> DataEndpoint<NextActionResponseModel> {
        return DataEndpoint(
            path: "identity/v1/register",
            method: .post,
            bodyParamaters: param.toDictionary()
        )
    }
    
    static func requestOtp(param: OtpRequestModel) -> DataEndpoint<OtpResponseModel> {
        return DataEndpoint(
            path: "identity/v1/verify",
            method: .post,
            bodyParamaters: param.toDictionary()
        )
    }
    
    static func verifyOtp(param: VerifyOtpRequestModel) -> DataEndpoint<NextActionResponseModel> {
        return DataEndpoint(
            path: "identity/v1/verify-otp",
            method: .post,
            bodyParamaters: param.toDictionary()
        )
    }
    
    static func login(param: LoginRequestModel) -> DataEndpoint<LoginResponseModel> {
        return DataEndpoint(
            path: "identity/v1/login",
            method: .post,
            bodyParamaters: param.toDictionary()
        )
    }
    
    static func socialLogin(param: SocialLoginRequestModel) -> DataEndpoint<LoginResponseModel> {
        return DataEndpoint(
            path: "identity/v1/idp_connect",
            method: .post,
            bodyParamaters: param.toDictionary()
        )
    }
    
    static func passwordRecoveryOtp(param: OtpRequestModel) -> DataEndpoint<PasswordRecoveryOtpResponseModel> {
        return DataEndpoint(
            path: "identity/v1/password-recovery-otp",
            method: .post,
            bodyParamaters: param.toDictionary()
        )
    }
    
    static func passwordRecovery(param: PasswordRecoveryOtpRequestModel) -> DataEndpoint<NextActionResponseModel> {
        return DataEndpoint(
            path: "identity/v1/password-recovery",
            method: .post,
            bodyParamaters: param.toDictionary()
        )
    }
    
    static func verifyLink(sessionId: String, identity: String) -> DataEndpoint<NextActionResponseModel> {
        return DataEndpoint(
            path: "identity/v1/verify-link",
            method: .post,
            bodyParamaters: [
                "session_id": sessionId,
                "identity": identity
            ]
        )
    }
    
}
