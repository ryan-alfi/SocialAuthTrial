//
//  ResponseData.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 08/11/23.
//

struct ResponseData<T: Decodable>: Decodable {
    var data: T
}
