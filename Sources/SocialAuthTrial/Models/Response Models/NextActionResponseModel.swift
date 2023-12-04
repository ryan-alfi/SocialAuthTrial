//
//  NextActionResponseModel.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 13/11/23.
//

enum NextStateAction: String {
    case login
    case idpLogin = "idp_login"
    case register
    case verification
}

struct NextActionResponseModel: Codable, Equatable {
    var nextState: String
    
    enum CodingKeys: String, CodingKey {
        case nextState = "next_state"
    }
}
