//
//  DataTransferError.swift
//  VisionPlusBSS
//
//  Created by Muhammad Affan on 17/11/23.
//

enum DataTransferError: Error {
    case parsingJSON(statusCode: Int)
    case errorModel(ErrorModel)
    case networkFailure(NetworkError)
}

extension DataTransferError: Equatable {
    
    static func == (lhs: DataTransferError, rhs: DataTransferError) -> Bool {
        switch lhs {
        case .parsingJSON(let lhsStatusCode):
            switch rhs {
            case .parsingJSON(let rhsStatusCode):
                return lhsStatusCode == rhsStatusCode
            default:
                return false
            }
        case .errorModel(let lhsErrorModel):
            switch rhs {
            case .errorModel(let rhsErrorModel):
                return lhsErrorModel == rhsErrorModel
            default:
                return false
            }
        case .networkFailure(let lhsNetworkError):
            switch rhs {
            case .networkFailure(let rhsNetworkError):
                return lhsNetworkError == rhsNetworkError
            default:
                return false
            }
        }
    }
    
}

extension DataTransferError {
    
    func dataTransferErrorMessage() -> String {
        switch self {
        case let .parsingJSON(statusCode):
            return "Unable to parse data : \(statusCode)"
        case let .errorModel(errorModel):
            return errorModel.message ?? ""
        case let .networkFailure(networkError):
            return networkError.networkErrorMessage()
        }
    }
    
    var errorModel: ErrorModel? {
        switch self {
        case .errorModel(let errorModel):
            return errorModel
        default:
            return nil
        }
    }
    
    var statusCode: Int {
        switch self {
        case .parsingJSON(let statusCode):
            return statusCode
        case .errorModel(let errorModel):
            return errorModel.statusCode
        case .networkFailure(let networkError):
            if networkError == .notConnected {
                return NSURLErrorNotConnectedToInternet
            } else {
                return -1
            }
        }
    }
    
}
