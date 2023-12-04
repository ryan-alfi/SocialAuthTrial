//
//  NetworkService.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 08/11/23.
//

import Foundation

protocol NetworkService {
    func request(endpoint: Requestable, completion: @escaping (Result<(Data?, HTTPURLResponse?), NetworkError>) -> Void)
}

class NetworkServiceImpl: NetworkService {
    
    @Injected(\.networkConfiguration) var config: NetworkConfigurable
    @Injected(\.networkSession) var session: NetworkSession
    
    func request(endpoint: Requestable, completion: @escaping (Result<(Data?, HTTPURLResponse?), NetworkError>) -> Void) {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            session.loadData(from: urlRequest) { (data, response, requestError) in
                DispatchQueue.main.async {
                    let response = (response as? HTTPURLResponse)
                    switch requestError?._code {
                    case NSURLErrorNotConnectedToInternet, -1020:
                        completion(.failure(.notConnected))
                    default:
                        completion(.success((data, response)))
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.urlGeneration))
            }
        }
    }
    
}
