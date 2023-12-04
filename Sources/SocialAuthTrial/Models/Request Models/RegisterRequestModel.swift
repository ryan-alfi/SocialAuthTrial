//
//  RegisterRequestModel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 08/11/23.
//

struct RegisterRequestModel: Encodable {
    var identity: String
    var identityType: String
    var password: String
    
    func toDictionary() -> [String: Any] {
        return [
            "identity": identity,
            "identity_type": identityType,
            "password": password
        ]
    }
    
    func toLoginRequestModel() -> LoginRequestModel {
        return LoginRequestModel(
            clientID: AppConstants.clientID,
            identity: identity,
            identityType: identityType,
            password: password,
            responseType: .code)
    }
    
}
