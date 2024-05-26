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
                Button("", systemImage: "heart", action:{
                    showMenu.toggle()
                    DBManagerImpl.insert(data: article,username: "dev")
                    FavouritesViewModelImpl.shared.getFavourites()
                }).tint(Color(hue: 0.83, saturation: 0.458, brightness: 1.0))
                Button("", systemImage: "trash", role: .destructive, action: {
                    print ("Delete")
                })
                
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
    
    struct SwipeActionsView: View {
        @State var showMenu: Bool = false
        var body: some View {
            List {
                Text("Swipe action test")
                
                    .swipeActions {
                        Button {
                            showMenu.toggle()
                        }label: {
                            Text("Menu")
                        }
                        
                        Button("", systemImage: "trash", role: .destructive, action: {
                            print ("Delete")
                        })
                        
                        Button {
                            print("Sup")
                        }label: {
                            Image(systemName: "checkmark")
                        }
                        .tint(.green)
                        
                    }
            }
            .confirmationDialog("Menu of options",
                                isPresented: $showMenu,
                                titleVisibility: .visible) {
                Button {
                    print("menu one")
                }label: {
                    Text("Menu one")
                }
                Button {
                    print("menu two")
                }label: {
                    Text("Menu two")
                }
                Button {
                    print("menu three")
                }label: {
                    Text("Menu three")
                }
            }
            
        }
    }



#Preview {
    ArticleView(article: Article.dummyData)
}
