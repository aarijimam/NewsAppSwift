//
//  DBManager.swift
//  NewsApp
//
//  Created by Aarij Imam on 26/05/2024.
//

import Foundation
import SQLite3


protocol DBManager{
    func openDatabase() -> OpaquePointer?
    static func createTable()
    
}

public let DBDirectoryUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//public let db:OpaquePointer

private enum Database: String {
    case Favourites
    case Articles
    
    var path: String? {
        return DBDirectoryUrl?.appendingPathComponent("\(self.rawValue).sqlite").relativePath
    }
}

class DBManagerImpl: DBManager,ObservableObject{
    static var db:OpaquePointer? = nil
    //var createFavouritesTableString = ""
    static let createFavouritesTableString = """
    CREATE TABLE Article (
        id VARCHAR(255),
        author VARCHAR(255),
        url VARCHAR(255) PRIMARY KEY,
        source VARCHAR(255),
        title VARCHAR(255),
        description TEXT,
        image VARCHAR(255),
        date DATE
    );
    """
    internal init() {
        DBManagerImpl.db = openDatabase()
        
        DBManagerImpl.createTable()
    }
    
    
    public let FavouritesPath = Database.Favourites.path
    public let ArticlesPath = Database.Articles.path
    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer?
        guard let FavoritesPath = FavouritesPath else {
            print("Favourites is nil.")
            return nil
        }
        if sqlite3_open(FavoritesPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(FavoritesPath)")
            return db
        } else {
            print("Unable to open database.")
            return db
        }
    }
    
    
    static func createTable(){
        // 1
        var createTableStatement: OpaquePointer?
        
        // 2
        if sqlite3_prepare_v2(DBManagerImpl.db, DBManagerImpl.createFavouritesTableString, -1, &createTableStatement, nil) ==
            SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nContact table created.")
            } else {
                print("\nContact table is not created.")
            }
        } else {
            print("\nCREATE TABLE statement is not prepared.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
    
    
    static let insertFavouritesStatementString = """
     INSERT INTO Article (id,author, url, source, title, description, image, date)
     VALUES (?,?,?,?,?,?,?,?);
     """
    
    static func insert(data:Article) {
        //print(data)
        var insertStatement: OpaquePointer?
        // 1
        if sqlite3_prepare_v2(DBManagerImpl.db, DBManagerImpl.insertFavouritesStatementString, -1, &insertStatement, nil) ==
            SQLITE_OK {
            let id:NSString = data.id.uuidString as NSString
            let author:NSString = (data.author ?? "") as NSString
            let url:NSString = (data.url ?? "") as NSString
            let source:NSString = (data.source ?? "") as NSString
            let title:NSString = (data.title ?? "") as NSString
            let description:NSString = (data.description ?? "") as NSString
            let image:NSString = (data.image ?? "") as NSString
            let date:Date? = data.date ?? .now
            
            print(id)
            print(author)
            print(url)
            print(source)
            // 2
            sqlite3_bind_text(insertStatement, 1, id.utf8String,-1, nil)
            // 3
            sqlite3_bind_text(insertStatement, 2, author.utf8String, -1, nil)
            //4
            sqlite3_bind_text(insertStatement, 3, url.utf8String, -1, nil)
            //5
            sqlite3_bind_text(insertStatement, 4, source.utf8String, -1, nil)
            //6
            sqlite3_bind_text(insertStatement, 5, title.utf8String, -1, nil)
            //7
            sqlite3_bind_text(insertStatement, 6, description.utf8String, -1, nil)
            //8
            sqlite3_bind_text(insertStatement, 7, image.utf8String, -1, nil)
            //9
            // Setup date (yyyy-MM-dd HH:mm:ss)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = formatter.string(from: date!)
            
            // Bind values to insert statement
            sqlite3_bind_text(insertStatement, 8, (dateString as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(DBManagerImpl.db))
                print("Failed to prepare table creation SQL: \(errmsg)")
                print("\nCould not insert row.")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(DBManagerImpl.db))
            print("Failed to prepare table creation SQL: \(errmsg)")
            print("\nINSERT statement is not prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    
    
    static let queryStatementString = "SELECT * FROM Article;"
    
    static func query() -> [Article]{
        var queryStatement: OpaquePointer?
        var articles: [Article] = []
        // 1
        if sqlite3_prepare_v2(DBManagerImpl.db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            // 2
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                // 3
                let id = sqlite3_column_text(queryStatement, 0)
                
                // 4
                let queryResultCol2 = sqlite3_column_text(queryStatement, 1)
                let author = String(cString: (queryResultCol2!))
                
                
                let queryResultCol3 = sqlite3_column_text(queryStatement, 2)
                let url = String(cString: queryResultCol3!)
                
                let queryResultCol4 = sqlite3_column_text(queryStatement, 3)
                let source = String(cString: queryResultCol4!)
                
                let queryResultCol5 = sqlite3_column_text(queryStatement, 4)
                let title = String(cString: queryResultCol5!)
                
                let queryResultCol6 = sqlite3_column_text(queryStatement, 5)
                let description = String(cString: queryResultCol6!)
                
                let queryResultCol7 = sqlite3_column_text(queryStatement, 6)
                let image = String(cString: queryResultCol7!)
                
                let queryResultCol8 = sqlite3_column_text(queryStatement, 7)
                let dateString = String(cString: queryResultCol8!)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Adjust the date format according to your date string format
                let date = dateFormatter.date(from: dateString)
                let article:Article = Article(author: author, url: url, source: source, title: title, description: description, image: image, date: date)
                articles.append(article)
//                // 5
//                print("\nQuery Result:")
//                print("\(id!) | \(author) | \(url) | \(source) | \(title) | \(description) | \(image) | \(date!)")
            }
            print("All queries printed!")
        } else {
            // 6
            let errorMessage = String(cString: sqlite3_errmsg(DBManagerImpl.db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        // 7
        sqlite3_finalize(queryStatement)
        return articles
    }
    
    static let deleteTableStatementString = "DROP TABLE Article;"
    
    static func deleteTable(){
        // 1
        var deleteTableStatement: OpaquePointer?
        // 2
        if sqlite3_prepare_v2(DBManagerImpl.db, DBManagerImpl.deleteTableStatementString, -1, &deleteTableStatement, nil) ==
            SQLITE_OK {
            // 3
            if sqlite3_step(deleteTableStatement) == SQLITE_DONE {
                print("\nArticle table deleted.")
            } else {
                print("\nArticle table is not deleted.")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(DBManagerImpl.db))
            print("\nQuery is not prepared \(errorMessage)")
            print("\nDELETE TABLE statement is not prepared.")
        }
        // 4
        sqlite3_finalize(deleteTableStatement)
    }
    
    static  func deleteFavourite(url:String){
        let queryStatement = """
DELETE FROM Article WHERE url = "\(url)";
"""
        // 1
        var deleteRowStatement: OpaquePointer?
        // 2
        if sqlite3_prepare_v2(DBManagerImpl.db, queryStatement, -1, &deleteRowStatement, nil) ==
            SQLITE_OK {
            // 3
            if sqlite3_step(deleteRowStatement) == SQLITE_DONE {
                print("\nFavourite deleted.")
            } else {
                print("\nFavourite is not deleted.")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(DBManagerImpl.db))
            print("\nQuery is not prepared \(errorMessage)")
            print("\nDELETE Favourite statement is not prepared.")
        }
        // 4
        sqlite3_finalize(deleteRowStatement)
    }
}
