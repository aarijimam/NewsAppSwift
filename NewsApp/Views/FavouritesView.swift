//
//  FavouritesView.swift
//  NewsApp
//
//  Created by Aarij Imam on 26/05/2024.
//

import SwiftUI

struct FavouritesView: View {
    //Access system capability to open up links
    @Environment(\.openURL) var openUrl
    //@ObservedObject var viewModel = FavouritesViewModelImpl()
    @ObservedObject var viewModel = FavouritesViewModelImpl.shared
    
    
    
    
    var body: some View {
        NavigationView{
            Group{
                List(viewModel.articles){item in
                    FavouriteArticleView(article: item)
                        .onTapGesture {
                            load(url: item.url)
                        }
                }
                .navigationTitle(Text("Favourites"))
            }
        }.onAppear(perform: viewModel.getFavourites)
    }
    
    
    func load(url: String?){
        guard let link = url,
              let url = URL(string: link) else {return}
        
        openUrl(url)
    }
}


#Preview {
    FavouritesView()
}
