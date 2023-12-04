//
//  NetworkConfig.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 08/11/23.
//

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
}

struct NetworkConfiguration: NetworkConfigurable {
    let baseURL: URL
    let headers: [String: String]
    
    init(baseURL: URL, headers: [String: String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
    }
}
