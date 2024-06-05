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
    case getFavourites
}

extension ArticleAPI:APIBuilder{
    var urlRequest: URLRequest {
        return URLRequest(url: self.baseURL.appendingPathComponent((self.path)))
    }
    
    var baseURL: URL {
        switch self{
        case .getNews:
            return URL(string: "https://api.lil.software")!
        case .getFavourites:
            return URL(string: "http://127.0.0.1:3000")!
        }
    }
    
    var path: String {
        return "/news"
    }
    
    
    
    
}
