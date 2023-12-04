//
//  Endpoint.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 08/11/23.
//

import Foundation

struct HeaderKey {
    static let apikey = "apikey"
    static let accept = "Accept"
    static let acceptLanguage = "Accept-Language"
    static let appVersion = "AppVersion"
    static let authorization = "Authorization"
    static let buildCode = "BuildCode"
    static let contentType = "Content-Type"
    static let deviceID = "device-id"
    static let lang = "lang"
    static let osVersion = "OSVersion"
    static let platform = "Platform"
    static let XDeviceID = "X-Device-Id"
    static let XDeviceName = "X-Device-Name"
    static let XDeviceModel = "X-Device-Model"
}

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethod { get }
    var queryParameters: [String: Any] { get }
    var headerParamaters: [String: String] { get }
    var bodyParamaters: [String: Any] { get }
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

enum RequestGenerationError: Error {
    case components
}

extension Requestable {
    
    func configureUrl(with config: NetworkConfigurable) throws -> URL {
        let baseURL = config.baseURL.absoluteString.last != "/" ? config.baseURL.absoluteString + "/" : config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(string: endpoint) else {
            throw RequestGenerationError.components
        }
        
        var urlQueryItems = [URLQueryItem]()
        
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        
        guard let url = urlComponents.url else {
            throw RequestGenerationError.components
        }
        
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.configureUrl(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = config.headers
        headerParamaters.forEach({ allHeaders.updateValue($1, forKey: $0) })
        
        if !bodyParamaters.isEmpty {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParamaters, options: .prettyPrinted)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        
        return urlRequest
    }
    
}

class Endpoint: Requestable {
    var path: String
    var isFullPath: Bool = false
    var useBaseResponse: Bool = true
    var method: HTTPMethod = .get
    var queryParameters: [String: Any] = [:]
    var headerParamaters: [String: String] = [:]
    var bodyParamaters: [String : Any] = [:]
    
    init(path: String,
         isFullPath: Bool = false,
         useBaseResponse: Bool = true,
         method: HTTPMethod = .get,
         queryParameters: [String: Any] = [:],
         headerParamaters: [String: String] = [:],
         bodyParamaters: [String : Any] = [:]) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.queryParameters = queryParameters
        self.headerParamaters = headerParamaters
        self.bodyParamaters = bodyParamaters
    }
}
