//
//  ExtensionResult.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/11/23.
//

import Foundation

extension Result {
    
    func getError() -> Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
    
}
