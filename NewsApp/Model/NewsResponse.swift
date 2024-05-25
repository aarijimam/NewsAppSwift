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
    let url: String?
    let source, title: String?
    let description: String?
    let image: String?
    let date: Date?
}


extension Article{
    static var dummyData:Article{
        .init(author: "Riley Hoffman",
              url: "https://abcnews.go.com/GMA/rapper-sean-kingston-arrested-california-raid-florida-mansion/story?id=110524642",
              source: "ABC News",
              title: "Rapper Sean Kingston arrested following raid at Florida mansion: Sheriff - ABC News",
              description: "He was arrested on numerous fraud and theft charges, authorities said.",
              image: "https://i.abcnewsfe.com/a/5b87918f-78be-41bc-a24f-530ed34c7355/GettyImages-1258424113_1716517910214_hpMain_16x9.jpg?w=1600",
              date: ISO8601DateFormatter().date(from: "2024-05-24T10:01:31Z")
              )
    }
}
