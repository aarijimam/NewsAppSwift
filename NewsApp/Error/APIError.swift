//
//  APIError.swift
//  NewsApp
//
//  Created by Aarij Imam on 25/05/2024.
//

import Foundation

enum APIError:Error{
    case decodingError
    case errorCode(Int)
    case unknown
}

extension APIError:LocalizedError{
    var errorDescription: String?{
        switch self{
        case .decodingError:
            return "Failed to decode the object from the service"
        case .errorCode(let code):
            return "\(code) - Something went wrong!"
        case .unknown:
            return "An unknown error occured!"
        }
    }
}
