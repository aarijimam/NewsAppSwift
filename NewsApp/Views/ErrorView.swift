//
//  ErrorView.swift
//  NewsApp
//
//  Created by Aarij Imam on 25/05/2024.
//

import SwiftUI

struct ErrorView: View {
    typealias ErrorViewActionHandler = () -> Void
    
    let error:Error
    let handler: ErrorViewActionHandler
    
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
            Spacer()
            VStack{
                Image(systemName: "exclamationmark.icloud.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 50, weight: .heavy))
                Text("Ooops!")
                    .foregroundStyle(.black)
                    .font(.system(size: 30, weight: .heavy))
                Text(error.localizedDescription)
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 15,weight: .light))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 2)
            }
            .padding(.top, 200)
            Spacer()
            Button(action:{
                
            },label: {
                Text("Retry")
            })
            .padding(.vertical, 15)
            .padding(.horizontal, 30)
            .background(Color.blue)
            .foregroundStyle(.white)
            .font(.system(size: 15,weight: .heavy))
            .cornerRadius(10)
            .frame(height: 300)
        }
    }
}

#Preview {
    ErrorView(error: APIError.decodingError)
}
