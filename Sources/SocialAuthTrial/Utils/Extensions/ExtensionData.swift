//
//  ExtensionData.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/11/23.
//

import Foundation

extension Data {
    
    func toObject<T: Decodable>(_ object: T.Type) -> T? {
        return try? JSONDecoder().decode(object, from: self)
    }
    
    func toDataTransferError() -> DataTransferError {
        let errorModel = self.toObject(ResponseError<ErrorModel>.self)!.error
        return DataTransferError.errorModel(errorModel)
    }
    
}
