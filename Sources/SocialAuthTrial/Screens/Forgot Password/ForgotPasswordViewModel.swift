//
//  ForgotPasswordViewModel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/10/23.
//

final class ForgotPasswordViewModel: BaseViewModel {
    
    @Injected(\.authUseCase) var authUseCase: AuthUseCase
    
    var countries = CountryModel.availableCountries()
    
    func updateSelectedCountry(country: CountryModel) {
        countries = countries.updateSelectedCountry(country: country)
    }
    
    func requestPasswordRecoveryOtp(param: OtpRequestModel) {
        self.data.setLoading(true)
        self.authUseCase.passwordRecoveryOtp(param: param, completion: { [weak self] result in
            self?.data.setLoading(false)
            switch result {
            case .success(let response):
                self?.data = .loaded(response)
            case .failure(let error):
                self?.data.setError(error)
            }
        })
    }
    
    func passwordRecovery(param: PasswordRecoveryOtpRequestModel) {
        self.data.setLoading(true)
        self.authUseCase.passwordRecovery(param: param, completion: { [weak self] result in
            self?.data.setLoading(false)
            switch result {
            case .success(let response):
                self?.data = .loaded(response)
            case .failure(let error):
                self?.data.setError(error)
            }
        })
    }
    
}
