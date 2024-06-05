//
//  FeedView.swift
//  NewsApp
//
//  Created by Aarij Imam on 25/05/2024.
//

import SwiftUI

struct FavouritesView: View {
    //Access system capability to open up links
    @Environment(\.openURL) var openUrl
    //Object is not lost when changing states maintains in memory
    @StateObject var viewModel = FavouritesViewModelImpl(service: NewsServiceImpl())
    
    var body: some View {
        NavigationView{
            Group{
                switch(viewModel.state){
                case .loading:
                    ProgressView()
                case .failed(error: let error):
                    ErrorView(error: error, handler: viewModel.getArticles)
                case .success(let articles):
                    List(articles){item in
                        ArticleView(article: item)
                            .onTapGesture {
                                load(url: item.url)
                            }
                    }
                    .navigationTitle(Text("News"))
                }
            }
        }.onAppear(perform: viewModel.getArticles)
    }
    
    func load(url: String?){
        guard let link = url,
              let url = URL(string: link) else {return}
        
        openUrl(url)
    }
}

#Preview {
    FeedView()
}
