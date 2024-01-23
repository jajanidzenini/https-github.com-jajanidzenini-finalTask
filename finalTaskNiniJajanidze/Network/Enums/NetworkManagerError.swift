//
//  NetworkManagerError.swift
//  FinalApplication
//
//  Created by Admin on 20.01.24.
//

enum NetworkManagerError: Error, CustomStringConvertible {
    case invalidURL
    case noData
    case invalidRequest
    case serverError
    case unknownError(String)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .noData:
            return "No data was received."
        case .invalidRequest:
            return "The request was invalid."
        case .serverError:
            return "A server error occurred."
        case .unknownError(let message):
            return "An unknown error occurred: \(message)"
        }
    }
}
