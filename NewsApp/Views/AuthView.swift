//
//  AuthView.swift
//  NewsApp
//
//  Created by Aarij Imam on 26/05/2024.
//

import SwiftUI

struct AuthView: View {
    @State private var currentViewShowing: String = "login" // login or signup
    @StateObject var favouriteModel = DBManagerImpl()
        
    var body: some View {
        
        if(currentViewShowing == "login") {
            LoginView(currentShowingView: $currentViewShowing)
                .preferredColorScheme(.light)
        } else if(currentViewShowing == "signup"){
            SignupView(currentShowingView: $currentViewShowing)
                .preferredColorScheme(.dark)
                .transition(.move(edge: .bottom))
        }else{
            HomeView(currentShowingView: $currentViewShowing)
                .transition(.move(edge: .bottom))
        }
  
    }
}

#Preview {
    AuthView()
}
