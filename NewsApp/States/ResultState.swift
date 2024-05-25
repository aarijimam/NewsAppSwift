//
//  ResultState.swift
//  NewsApp
//
//  Created by Aarij Imam on 25/05/2024.
//

import Foundation

//change the way app looks based on states in ViewModels
enum ResultState{
    case loading
    //return articles if success
    case success(content: [Article])
    case failed(error: Error)
}
