//
//  ResponseError.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 08/11/23.
//

struct ResponseError<T: Decodable>: Decodable {
    var error: T
}
