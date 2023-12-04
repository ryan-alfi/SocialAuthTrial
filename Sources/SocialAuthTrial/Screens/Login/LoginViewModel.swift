//
//  LoginViewModel.swift
//  Pods
//
//  Created by Muhammad Affan on 16/10/23.
//

class LoginViewModel: BaseViewModel {
    
    @Injected(\.authUseCase) var authUseCase: AuthUseCase
    
    var countries = CountryModel.availableCountries()
    
    func updateSelectedCountry(country: CountryModel) {
        countries = countries.updateSelectedCountry(country: country)
    }
    
    func login(param: LoginRequestModel) {
        self.data.setLoading(true)
        self.authUseCase.login(param: param, completion: { [weak self] result in
            self?.data.setLoading(false)
            switch result {
            case .success(let response):
                self?.data = .loaded(response)
            case .failure(let error):
                self?.data.setError(error)
            }
        })
    }
    
    func socialLogin(param: SocialLoginRequestModel) {
        self.data.setLoading(true)
        self.authUseCase.socialLogin(param: param, completion: { [weak self] result in
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
