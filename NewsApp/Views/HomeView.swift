//
//  HomeView.swift
//  NewsApp
//
//  Created by Aarij Imam on 25/05/2024.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("systemThemeEnabled") private var systemThemeEnabled = false
    //@AppStorage("User") private var user_:String = "NULL"
    @Binding var currentShowingView: String
    @Binding var userID: String
    @Binding var passwordID: String
    
    
    
    
    private let themeManager = ThemeManager()
    
    var body: some View{
        TabView{
            FeedView()
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("Feed")
                }
            FavouritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favourites")
                }
            SettingsView(darkModeEnabled: $darkModeEnabled, systemThemeEnabled: $systemThemeEnabled,
                         currentShowingView: $currentShowingView,userID: $userID,passwordID: $passwordID,themeManager: themeManager)
            .tabItem{
                Image(systemName: "gearshape")
                Text("Settings")
            }
        }
    }
}

