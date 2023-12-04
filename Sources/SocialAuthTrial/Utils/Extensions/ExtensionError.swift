//
//  ExtensionError.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 08/11/23.
//

import Foundation

extension Error {
    
    func getErrorMessage() -> String {
        if let error = self as? DataTransferError {
            return error.dataTransferErrorMessage()
        }
        
        return "Terjadi Kesalahan"
    }
    
    func toDataTransferError() -> DataTransferError? {
        return self as? DataTransferError
    }
    
    func toNetworkError() -> NetworkError? {
        return self as? NetworkError
    }
    
    func statusCode() -> Int {
        return toDataTransferError()?.statusCode ?? -1
    }
}

extension NSError {
    
    static var noInternetError: NSError {
        return NSError(domain: "The Internet connection appears to be offline.", code: NSURLErrorNotConnectedToInternet)
    }
    
}
