//
//  HomeView.swift
//  NewsApp
//
//  Created by Aarij Imam on 25/05/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View{
        TabView{
            FeedView()
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("Feed")
                }
            SettingsView()
                .tabItem{
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    HomeView()
}
