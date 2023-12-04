//
//  SocialLoginRequestModel.swift
//  VisionPlusBSS
//
//  Created by ERWINDO SIANIPAR on 15/11/2023.
//

struct SocialLoginRequestModel {
    let clientID: String
    let token: String
    let provider: String
    let responseType: ResponseType
    
    func toDictionary() -> [String: Any] {
        return [
            "client_id": clientID,
            "token": token,
            "provider": provider,
            "response_type": responseType.rawValue,
        ]
    }
}
