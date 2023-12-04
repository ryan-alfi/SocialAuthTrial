//
//  NetworkInjectionKey.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 08/11/23.
//

import Foundation

struct NetworkServiceInjectionKey: InjectionKey {
    static var currentValue: NetworkService = NetworkServiceImpl()
}

struct DataTransferServiceInjectionKey: InjectionKey {
    static var currentValue: DataTransferService = DataTransferServiceImpl()
}

struct NetworkConfigurationInjectionKey: InjectionKey {
    static var currentValue: NetworkConfigurable = NetworkConfiguration(
        baseURL: URL(string: "https://temp-bss-stg.visionplus.id")!,
        headers: [
            HeaderKey.contentType: "application/json"
        ]
    )
}

struct NetworkSessionInjectionKey: InjectionKey {
    static var currentValue: NetworkSession = NetworkSessionImpl()
}

extension InjectedValue {
    
    var networkSession: NetworkSession {
        get { Self[NetworkSessionInjectionKey.self] }
        set { Self[NetworkSessionInjectionKey.self] = newValue }
    }

    var networkConfiguration: NetworkConfigurable {
        get { Self[NetworkConfigurationInjectionKey.self] }
        set { Self[NetworkConfigurationInjectionKey.self] = newValue }
    }
    
    var networkService: NetworkService {
        get { Self[NetworkServiceInjectionKey.self] }
        set { Self[NetworkServiceInjectionKey.self] = newValue }
    }
    
    var dataTransferService: DataTransferService {
        get { Self[DataTransferServiceInjectionKey.self] }
        set { Self[DataTransferServiceInjectionKey.self] = newValue }
    }
    
}
