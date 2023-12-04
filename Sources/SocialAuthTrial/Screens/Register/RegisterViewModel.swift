//
//  RegisterViewModel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/10/23.
//

final class RegisterViewModel: LoginViewModel {
    
    // MARK: - Network Calls
    
    func register(param: RegisterRequestModel) {
        self.data.setLoading(true)
        self.authUseCase.register(param: param, completion: { [weak self] result in
            self?.data.setLoading(false)
            switch result {
            case .success:
                // currently the nextState always return "verification" but there is a possibility that it returns bypass, need to confirm this before release to production
                self?.requestOtp(param: OtpRequestModel(identity: param.identity, identityType: param.identityType))
            case .failure(let error):
                if error.toDataTransferError()?.errorModel?.nextState == NextStateAction.verification.rawValue {
                    self?.requestOtp(param: OtpRequestModel(identity: param.identity, identityType: param.identityType))
                } else {
                    self?.data.setError(error)
                }
            }
        })
    }

    func requestOtp(param: OtpRequestModel) {
        self.data.setLoading(true)
        self.authUseCase.requestOtp(param: param, completion: { [weak self] result in
            self?.data.setLoading(false)
            switch result {
            case .success(let response):
                self?.data = .loaded(response)
            case .failure(let error):
                self?.data.setError(error)
            }
        })
    }
    
    func verifyOtp(param: VerifyOtpRequestModel, loginParam: LoginRequestModel) {
        self.data.setLoading(true)
        self.authUseCase.verifyOtp(param: param, completion: { [weak self] result in
            switch result {
            case .success:
                self?.login(param: loginParam)
            case .failure(let error):
                self?.data.setLoading(false)
                self?.data.setError(error)
            }
        })
    }
    
}
