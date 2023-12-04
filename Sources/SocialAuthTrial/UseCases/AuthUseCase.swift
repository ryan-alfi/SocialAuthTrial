//
//  AuthUseCase.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 08/11/23.
//

protocol AuthUseCase {
    func register(param: RegisterRequestModel, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void)
    func requestOtp(param: OtpRequestModel, completion: @escaping (Result<OtpResponseModel, Error>) -> Void)
    func verifyOtp(param: VerifyOtpRequestModel, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void)
    func login(param: LoginRequestModel, completion: @escaping (Result<LoginResponseModel, Error>) -> Void)
    func socialLogin(param: SocialLoginRequestModel, completion: @escaping (Result<LoginResponseModel, Error>) -> Void)
    func passwordRecoveryOtp(param: OtpRequestModel, completion: @escaping (Result<PasswordRecoveryOtpResponseModel, Error>) -> Void)
    func passwordRecovery(param: PasswordRecoveryOtpRequestModel, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void)
    func verifyLink(sessionId: String, identity: String, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void)
}

class AuthUseCaseImpl: AuthUseCase {
    
    @Injected(\.authRepository) var repository: AuthRepository
    
    func register(param: RegisterRequestModel, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void) {
        repository.register(param: param, completion: completion)
    }
    
    func requestOtp(param: OtpRequestModel, completion: @escaping (Result<OtpResponseModel, Error>) -> Void) {
        repository.requestOtp(param: param, completion: completion)
    }
    
    func verifyOtp(param: VerifyOtpRequestModel, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void) {
        repository.verifyOtp(param: param, completion: completion)
    }
    
    func socialLogin(param: SocialLoginRequestModel, completion: @escaping (Result<LoginResponseModel, Error>) -> Void) {
        repository.socialLogin(param: param, completion: completion)
    }
    
    func login(param: LoginRequestModel, completion: @escaping (Result<LoginResponseModel, Error>) -> Void) {
        repository.login(param: param, completion: completion)
    }
    
    func passwordRecoveryOtp(param: OtpRequestModel, completion: @escaping (Result<PasswordRecoveryOtpResponseModel, Error>) -> Void) {
        repository.passwordRecoveryOtp(param: param, completion: completion)
    }
    
    func passwordRecovery(param: PasswordRecoveryOtpRequestModel, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void) {
        repository.passwordRecovery(param: param, completion: completion)
    }
    
    func verifyLink(sessionId: String, identity: String, completion: @escaping (Result<NextActionResponseModel, Error>) -> Void) {
        repository.verifyLink(sessionId: sessionId, identity: identity, completion: completion)
    }
    
}
