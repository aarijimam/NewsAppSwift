//
//  FavouritesViewModel.swift
//  NewsApp
//
//  Created by Aarij Imam on 26/05/2024.
//

import Foundation
import Combine


protocol FavouritesViewModel{
    func getFavourites()
}


class FavouritesViewModelImpl: ObservableObject,FavouritesViewModel{
    
//    internal init() {
//        FavouritesViewModelImpl.articles = DBManagerImpl.query()
//    }
    
    var subscriptions = Set<AnyCancellable>()


    
    @Published var articles:[Article] = []
    
    public static let shared = FavouritesViewModelImpl()  // <--- here
    
    func getFavourites(){
        self.articles = DBManagerImpl.query(username: User.shared.username)
        objectWillChange.send()
    }
    
}
