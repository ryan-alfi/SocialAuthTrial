//
//  OtpRequestModel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 13/11/23.
//

struct OtpRequestModel {
    var identity: String
    var identityType: String
    
    func toDictionary() -> [String: Any] {
        return [
            "identity": identity,
            "identity_type": identityType
        ]
    }
    
}
