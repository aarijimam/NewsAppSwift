//
//  ArticleView.swift
//  NewsApp
//
//  Created by Aarij Imam on 25/05/2024.
//

import SwiftUI
//used to cache images //third party dependency
import URLImage

struct ArticleView: View {
    
    let article: Article
    
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
                    .foregroundColor(.black)
                    .font(.system(size:18, weight: .semibold))
                HStack{
                    Text(article.source ?? "N/A")
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Spacer()
                    Text(article.date ?? Date(), style: .date)
                        .foregroundStyle(.gray)
                        .font(.footnote)
                        .padding(.horizontal)
                        .lineLimit(1)
                }
            }
        }
    }
}

struct PlaceholderImageView:View{
    var body: some View{
        Image(systemName: "photo.fill")
            .foregroundColor(.white)
            .background(Color.gray)
            .frame(width:100, height: 100)
    }
}

#Preview {
    ArticleView(article: Article.dummyData)
}
