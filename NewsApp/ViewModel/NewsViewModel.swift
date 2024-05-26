//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Aarij Imam on 25/05/2024.
//

import Foundation
import Combine

protocol NewsViewModel{
    func getArticles()
}

//class because want it to be observable object to observe the changes, adhering to protocol NewsViewModel
class NewsViewModelImpl: ObservableObject,NewsViewModel{
    //using concept of dependency injection
    //inject news service into our class
    private let service: NewsService
    
    //protect it from within the class but access it from outside using private(set)
    private(set) var articles = [Article]()
    
    //when you call service you want to keep it in memory, so collection to hold requests
    private var cancellables = Set<AnyCancellable>()
    
    //add published to listen to whenever the state changes
    @Published private(set) var state: ResultState = .loading
    
    init(service: NewsService){
        self.service = service
    }
    
    func getArticles() {
        
        self.state = .loading
        
        //when you call a service you need to store it in memory or it be disposed off thats why you use cancellable
        let cancellable = service
            .request(from: .getNews)
        
        //allows us to listen to success or failure, also allows us to listen to when it is finished
            .sink{res in
                switch res{
                case .finished:
                    //Send back article
                    self.state = .success(content: self.articles)
                case .failure(let error):
                    //Send Back Error
                    self.state = .failed(error: error)

                }
            } receiveValue: {
                response in self.articles = response.articles
            }
        //hold cancellable in memory
        self.cancellables.insert(cancellable)
    }
}
