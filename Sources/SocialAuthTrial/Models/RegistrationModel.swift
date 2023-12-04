//
//  RegistrationModel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 08/11/23.
//

struct RegistrationModel: Codable {
    var nextState: String
    
    enum CodingKeys: String, CodingKey {
        case nextState = "next_state"
    }
}
