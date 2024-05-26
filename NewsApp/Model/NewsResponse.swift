//
//  NewsResponse.swift
//  NewsApp
//
//  Created by Aarij Imam on 25/05/2024.
//

import Foundation

struct ArticleResponse: Codable {
    let articles: [Article]
}

struct Article: Codable, Identifiable {
    
     init(author: String? = nil, url: String? = nil, source: String? = nil, title: String? = nil, description: String? = nil, image: String? = nil, date: Date? = nil) {
        self.author = author
        self.url = url
        self.source = source
        self.title = title
        self.description = description
        self.image = image
        self.date = date
    }
    

    let id: UUID = UUID()
    var author: String?
    var url: String?
    var source: String?
    var title: String?
    var description: String?
    var image: String?
    var date: Date?
    

//    enum CodingKeys: String, CodingKey {
//        case author, url, source, title, image, date
//        case welcomeDescription = "description"
//    }
}

extension Article {
    
    static var dummyData: Article {
        .init(author: "Adam Edelman, Monica Alba, Frank Thorp V, Alex Moe",
              url: "https://www.nbcnews.com/politics/donald-trump/trump-impeachment-trial-day-2-kicks-case-against-him-n1257246",
              source: "NBC News",
              title: "Never-seen-before security video of Capitol riot to open Trump impeachment trial Day 2 - NBC News",
              description: "Dems to open Day 2 trial arguments against Trump with 'never-seen-before\" riot footage",
              image: "https://media2.s-nbcnews.com/j/newscms/2021_06/3448074/210205-impeachment-main-bar-cs-428p_fcaf4fdb04ac2ff3682a3783343f300b.nbcnews-fp-1200-630.jpg",
              date: Date())
    }
}
