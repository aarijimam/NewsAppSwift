//
//  NewsResponse.swift
//  NewsApp
//
//  Created by Aarij Imam on 25/05/2024.
//

import Foundation

// MARK: - Welcome
struct NewsResponse: Codable {
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable,Identifiable {
    var id = UUID()
    let author: String?
    let url: String
    let source, title: String
    let description: String?
    let image: String?
    let date: Date
}
