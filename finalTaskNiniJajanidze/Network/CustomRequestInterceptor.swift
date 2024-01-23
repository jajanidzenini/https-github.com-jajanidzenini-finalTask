//
//  CustomRequestInterceptor.swift
//  finalTaskNiniJajanidze
//
//  Created by niniku on 15.01.24.
//

import Foundation
import Alamofire

class CustomRequestInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        logRequest(urlRequest)
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        print("Retry request: \(request.request?.url?.absoluteString ?? "") due to error: \(error.localizedDescription)")
        completion(.doNotRetry)
    }
    
    private func logRequest(_ request: URLRequest) {
        if let url = request.url?.absoluteString {
            print("Request URL: \(url)")
        }
        if let method = request.httpMethod {
            print("Method: \(method)")
        }
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
    }
    
    func logResponse<T>(_ response: DataResponse<T, AFError>) {
        if let url = response.request?.url?.absoluteString {
            print("Response URL: \(url)")
        }
        print("Status Code: \(response.response?.statusCode ?? 0)")
        if let data = response.data, let responseBody = String(data: data, encoding: .utf8) {
            print("Response Body: \(responseBody)")
        }
    }
}

