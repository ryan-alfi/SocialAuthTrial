//
//  AuthRepository.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 08/11/23.
//

protocol AuthRepository {
    func register(param: RegisterRequestModel, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void)
    func requestOtp(param: OtpRequestModel, completion: @escaping (Result<OtpResponseModel, Error>) -> Void)
    func verifyOtp(param: VerifyOtpRequestModel, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void)
    func login(param: LoginRequestModel, completion: @escaping (Result<LoginResponseModel, Error>) -> Void)
    func socialLogin(param: SocialLoginRequestModel, completion: @escaping (Result<LoginResponseModel, Error>) -> Void)
    func passwordRecoveryOtp(param: OtpRequestModel, completion: @escaping (Result<PasswordRecoveryOtpResponseModel, Error>) -> Void)
    func passwordRecovery(param: PasswordRecoveryOtpRequestModel, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void)
    func verifyLink(sessionId: String, identity: String, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void)
}

class AuthRepositoryImpl: AuthRepository {
    
    @Injected(\.dataTransferService) var dataTransferService: DataTransferService
    
    func register(param: RegisterRequestModel, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void) {
        dataTransferService.request(with: AuthEndpoint.register(param: param), completion: completion)
    }
    
    func requestOtp(param: OtpRequestModel, completion: @escaping (Result<OtpResponseModel, Error>) -> Void) {
        dataTransferService.request(with: AuthEndpoint.requestOtp(param: param), completion: completion)
    }
    
    func verifyOtp(param: VerifyOtpRequestModel, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void) {
        dataTransferService.request(with: AuthEndpoint.verifyOtp(param: param), completion: completion)
    }
    
    func login(param: LoginRequestModel, completion: @escaping (Result<LoginResponseModel, Error>) -> Void) {
        dataTransferService.request(with: AuthEndpoint.login(param: param), completion: completion)
    }
    
    func socialLogin(param: SocialLoginRequestModel, completion: @escaping (Result<LoginResponseModel, Error>) -> Void) {
        dataTransferService.request(with: AuthEndpoint.socialLogin(param: param), completion: completion)
    }
    
    func passwordRecoveryOtp(param: OtpRequestModel, completion: @escaping (Result<PasswordRecoveryOtpResponseModel, Error>) -> Void) {
        dataTransferService.request(with: AuthEndpoint.passwordRecoveryOtp(param: param), completion: completion)
    }
    
    func passwordRecovery(param: PasswordRecoveryOtpRequestModel, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void) {
        dataTransferService.request(with: AuthEndpoint.passwordRecovery(param: param), completion: completion)
    }
    
    func verifyLink(sessionId: String, identity: String, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void) {
        dataTransferService.request(with: AuthEndpoint.verifyLink(sessionId: sessionId, identity: identity), completion: completion)
    }
    
}
