//
//  Loadable.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 13/11/23.
//

enum Loadable<T> {
    case none
    case loading(T?, Bool)
    case loaded(T)
    case failure(T?, Error)
    
    var value: T? {
        switch self {
        case let .loaded(value):
            return value
        case let .loading(lastValue, _):
            return lastValue
        case let .failure(lastValue, _):
            return lastValue
        default:
            return nil
        }
    }
    
    var error: Error? {
        switch self {
        case let .failure(_, error):
            return error
        default:
            return nil
        }
    }
    
    mutating func setLoading(_ loading: Bool) {
        self = .loading(value, loading)
    }
    
    mutating func setError(_ error: Error) {
        self = .failure(value, error)
    }
    
}
