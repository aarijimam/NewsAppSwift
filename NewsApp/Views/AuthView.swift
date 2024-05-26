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
    @AppStorage("username") var userID: String = "null"
    @AppStorage("password") var passwordID: String = "null"
        
    var body: some View {

        if(currentViewShowing == "login") {
            LoginView(currentShowingView: $currentViewShowing,userID: $userID,passwordID: $passwordID)
                .preferredColorScheme(.light)
        } else if(currentViewShowing == "signup"){
            SignupView(currentShowingView: $currentViewShowing,userID: $userID,passwordID: $passwordID)
                .preferredColorScheme(.dark)
                .transition(.move(edge: .bottom))
        }else{
            HomeView(currentShowingView: $currentViewShowing,userID: $userID,passwordID: $passwordID)
                .transition(.move(edge: .bottom))
        }
  
    }
}

#Preview {
    AuthView()
}
