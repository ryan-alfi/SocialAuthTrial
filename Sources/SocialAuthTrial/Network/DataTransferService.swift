//
//  DataTransferService.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 08/11/23.
//

import Foundation

final class DataEndpoint<T: Any>: Endpoint {}

protocol DataTransferService {
    func request<T: Decodable>(with endpoint: DataEndpoint<T>, completion: @escaping ((Result<T, Error>) -> Void))
}

class DataTransferServiceImpl: DataTransferService {
    
    @Injected(\.networkService) var networkService: NetworkService
    
    func request<T: Decodable>(with endpoint: DataEndpoint<T>, completion: @escaping ((Result<T, Error>) -> Void)) {
        self.networkService.request(endpoint: endpoint) { result in
            switch result {
            case let .success((data, response)):
                let statusCode = response?.statusCode ?? -1
                guard let data = data else {
                    completion(.failure(DataTransferError.parsingJSON(statusCode: statusCode)))
                    return
                }
                
                if endpoint.useBaseResponse, let result = try? JSONDecoder().decode(ResponseData<T>.self, from: data) {
                    completion(.success(result.data))
                } else if let result = try? JSONDecoder().decode(T.self, from: data) {
                    completion(.success(result))
                } else if let result = try? JSONDecoder().decode(ResponseError<ErrorModel>.self, from: data) {
                    var errorModel = result.error
                    errorModel.statusCode = statusCode
                    completion(.failure(DataTransferError.errorModel(errorModel)))
                } else {
                    completion(.failure(DataTransferError.parsingJSON(statusCode: statusCode)))
                }
                
            case .failure(let error):
                completion(.failure(DataTransferError.networkFailure(error)))
            }
        }
    }
    
}
