//
//  NetworkError.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/11/23.
//

enum NetworkError: Error {
    case notConnected
    case urlGeneration
}

extension NetworkError {
    
    func networkErrorMessage() -> String {
        switch self {
        case .notConnected:
            return "No internet connection"
        case .urlGeneration:
            return "Source not found"
        }
    }
    
}
