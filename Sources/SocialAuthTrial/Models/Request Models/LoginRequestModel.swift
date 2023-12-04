//
//  LoginRequestModel.swift
//  VisionPlusBSS
//
//  Created by ERWINDO SIANIPAR on 15/11/2023.
//

struct LoginRequestModel {
    let clientID: String
    let identity: String
    let identityType: String
    let password: String
    let responseType: ResponseType
    
    func toDictionary() -> [String: Any] {
        return [
            "client_id": clientID,
            "identity": identity,
            "identity_type": identityType,
            "password": password,
            "response_type": responseType.rawValue,
        ]
    }
}
