//
//  ErrorView.swift
//  NewsApp
//
//  Created by Aarij Imam on 25/05/2024.
//

import SwiftUI

typealias EmptyStateActionHandler = () -> Void

struct ErrorView: View {
    
    private let handler: EmptyStateActionHandler
    private var error: Error
    
    internal init(
        error: Error,
        handler: @escaping EmptyStateActionHandler) {
        self.error = error
        self.handler = handler
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "exclamationmark.icloud.fill")
                .foregroundColor(.red)
                .font(.system(size: 50, weight: .heavy))
            Text("Ooops...")
                .font(.system(size: 30, weight: .heavy))
            Text(error.localizedDescription)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            Spacer()
            Button("Retry") {
                handler()
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 10)
            .font(.system(size: 20, weight: .bold))
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            Spacer()
        }
    }
}

#Preview {
    ErrorView(error: APIError.decodingError){}
}
