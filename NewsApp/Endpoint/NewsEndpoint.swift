//
//  NewsEndpoint.swift
//  NewsApp
//
//  Created by Aarij Imam on 25/05/2024.
//

import Foundation

protocol APIBuilder{
    var urlRequest: URLRequest {get}
    var baseURL: URL {get}
    var path: String{get}
}

enum ArticleAPI {
    case getNews
}

extension ArticleAPI:APIBuilder{
    var urlRequest: URLRequest {
        return URLRequest(url: self.baseURL.appendingPathComponent((self.path)))
    }
    
    var baseURL: URL {
        switch self{
        case .getNews:
            return URL(string: "https://api.lil.software")!
        }
    }
    
    var path: String {
        return "/news"
    }
    
    
}
