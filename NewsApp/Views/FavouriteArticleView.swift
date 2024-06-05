//
//  ArticleView.swift
//  NewsApp
//
//  Created by Aarij Imam on 25/05/2024.
//

import SwiftUI
//used to cache images //third party dependency
import URLImage

struct FavouriteArticleView: View {
    
    let article: Article
    @State var showMenu: Bool = false
    
    var body: some View {

            HStack{
                if let imgUrl = article.image,
                   let url = URL(string: imgUrl){
                    URLImage(url,
                             identifier: article.id.uuidString,
                             failure: {error, _ in
                        
                        PlaceholderImageView()
                        
                    },
                             content: {image in image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    })
                    .environment(\.urlImageOptions, URLImageOptions(
                        fetchPolicy:
                                .returnStoreElseLoad(downloadDelay: 0.25))
                    )
                    .frame(width:100,height: 100)
                    .cornerRadius(10)
                }else{
                    PlaceholderImageView()
                }
                
                
                VStack(alignment: .leading, spacing: 4){
                    Text(article.title ?? "")
                        .foregroundColor(Theme.textColor)
                        .font(.system(size:16, weight: .semibold))
                        .lineLimit(3)
                    Text(article.source ?? "N/A")
                        .foregroundColor(.gray)
                        .font(.system(size: 12, weight: .regular))
                    if let date = article.date{
                        HStack{
                            Text(date, style: .date)
                                .font(.system(size: 12, weight: .bold))
                            Text(date, style: .time)
                        }.foregroundStyle(.gray)
                            .font(.footnote)
                            .lineLimit(1)
                    }
                    
                }
            }
            .swipeActions {
                Button("", systemImage: "trash",role: .destructive, action: {
                    DBManagerImpl.deleteUserFavourite(url: (article.url ?? ""), user: (User.shared.username) )
                    FavouritesViewModelImpl.shared.getFavourites()
                    print ("Delete")
                })
                
            }
        
        }
    }
    


#Preview {
    ArticleView(article: Article.dummyData)
}
