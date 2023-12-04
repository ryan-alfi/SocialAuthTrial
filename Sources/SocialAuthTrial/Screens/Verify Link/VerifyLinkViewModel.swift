//
//  VerifyLinkViewModel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 31/10/23.
//

final class VerifyLinkViewModel: BaseViewModel {
    
    @Injected(\.authUseCase) var authUseCase: AuthUseCase
    var sessionId: String
    var identity: String
    
    init(sessionId: String, identity: String) {
        self.sessionId = sessionId
        self.identity = identity
    }
    
    func verifyLink() {
        data.setLoading(true)
        authUseCase.verifyLink(sessionId: sessionId, identity: identity, completion: { [weak self] result in
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
