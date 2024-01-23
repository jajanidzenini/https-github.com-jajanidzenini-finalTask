//
//  NetworkService.swift
//  finalTaskNiniJajanidze
//
//  Created by niniku on 15.01.24.
//

import Foundation
import Alamofire

class NetworkService {
    
    static let shared = NetworkService()
    
    private let session: Session
    private let interceptor: CustomRequestInterceptor
    
    private init() {
        interceptor = CustomRequestInterceptor()
        self.session = Session(interceptor: interceptor)
    }
    
    func getData<T: Codable>(from urlString: String,
                             method: HTTPMethod = .get,
                             completion: @escaping (Result<T, NetworkServiceError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        session.request(url, method: method)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: T.self) { response in
                self.interceptor.logResponse(response)
                switch response.result {
                case .success(let value):
                    if let responseData = response.data, !responseData.isEmpty {
                        completion(.success(value))
                    } else {
                        completion(.failure(.noData))
                    }
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        switch statusCode {
                        case 400...499:
                            completion(.failure(.invalidRequest))
                        case 500...599:
                            completion(.failure(.serverError))
                        default:
                            completion(.failure(.unknownError(error.localizedDescription)))
                        }
                    } else if let urlError = error.asAFError, urlError.isInvalidURLError {
                        completion(.failure(.invalidURL))
                    } else {
                        completion(.failure(.unknownError(error.localizedDescription)))
                    }
                    
                }
            }
    }
}

enum NetworkServiceError: Error {
    case invalidURL
    case noData
    case invalidRequest
    case serverError
    case unknownError(String)
}

// You might want to extend NetworkServiceError to provide more detailed error descriptions.
extension NetworkServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No Data"
        case .invalidRequest:
            return "Invalid Request"
        case .serverError:
            return "Server Error"
        case .unknownError(let description):
            return "Unknown Error: \(description)"
        }
    }
}
