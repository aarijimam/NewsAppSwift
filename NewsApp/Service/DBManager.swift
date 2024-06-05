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
    static func createTable(queryString:String)
    
}

public let DBDirectoryUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//public let db:OpaquePointer

private enum Database: String {
    case Favourites
    case Articles
    
    var path: String? {
        print(self.rawValue)
        return DBDirectoryUrl?.appendingPathComponent("\(self.rawValue).sqlite").relativePath
    }
}

class DBManagerImpl: DBManager,ObservableObject{
    static var db:OpaquePointer? = nil
    //var createFavouritesTableString = ""
    
    let createArticleTable = """
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
    
    let createFavouriteTable = """
    CREATE TABLE FavoriteArticle(
        ArticleURL VARCHAR(255),
        Username VARCHAR(255),
        PRIMARY KEY (ArticleURL, Username),
        FOREIGN KEY(ArticleURL) REFERENCES Article(url),
        FOREIGN KEY(Username) REFERENCES User(username)
        );
    """
    
    let createUserTable = """
        CREATE TABLE User(
            username VARCHAR(255) PRIMARY KEY,
            password VARCHAR(255)
            );
    """
    
    
    internal init() {
        DBManagerImpl.db = openDatabase()
        
        DBManagerImpl.createTable(queryString: createArticleTable)
        DBManagerImpl.createTable(queryString: createUserTable)
        DBManagerImpl.createTable(queryString: createFavouriteTable)
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
    
    
    static func createTable(queryString:String){
        // 1
        var createTableStatement: OpaquePointer?
        
        // 2
        if sqlite3_prepare_v2(DBManagerImpl.db, queryString, -1, &createTableStatement, nil) ==
            SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nTable created.")
            } else {
                print("\nTable is not created.")
            }
        } else {
            print("\nTable statement is not prepared.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
    
    
    static let insertFavouritesStatementString = """
     INSERT INTO Article (id,author, url, source, title, description, image, date)
     VALUES (?,?,?,?,?,?,?,?);
     """
    
    static let insertArticleStatementString = """
             INSERT INTO Article (id,author, url, source, title, description, image, date)
             VALUES (?,?,?,?,?,?,?,?);
        """
    static let insertFavoriteArticleStatementString = """
        INSERT OR IGNORE INTO FavoriteArticle(Username, ArticleURL) VALUES (?, ?)
        """
    
    static func insert(data:Article,username:String) {
        //print(data)
        var insertStatement: OpaquePointer?
        var insertFavoriteArticleStatement: OpaquePointer?
        // 1
        if sqlite3_prepare_v2(DBManagerImpl.db, DBManagerImpl.insertArticleStatementString, -1, &insertStatement, nil) ==
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
        
        // Prepare the statement for FavoriteArticle
        if sqlite3_prepare_v2(DBManagerImpl.db, insertFavoriteArticleStatementString, -1, &insertFavoriteArticleStatement, nil) == SQLITE_OK {
            
            let username: NSString = username as NSString
            let url: NSString = (data.url ?? "") as NSString
            
            // Bind the values to the insert statement
            sqlite3_bind_text(insertFavoriteArticleStatement, 1, username.utf8String, -1, nil)
            sqlite3_bind_text(insertFavoriteArticleStatement, 2, url.utf8String, -1, nil)
            
            if sqlite3_step(insertFavoriteArticleStatement) == SQLITE_DONE {
                print("Successfully inserted row into FavoriteArticle.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(DBManagerImpl.db))
                print("Failed to insert row into FavoriteArticle: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(DBManagerImpl.db))
            print("Failed to prepare insert statement for FavoriteArticle: \(errmsg)")
        }
        
        // Finalize the statement for FavoriteArticle
        sqlite3_finalize(insertFavoriteArticleStatement)
        
    }
    
    static let insertUserStatementString = """
        INSERT INTO User(username, password) VALUES (?, ?);
        """
    
    static func insert(user:User) -> Bool {
        var insertStatement: OpaquePointer?
        var status: Bool = false

        print(user)
        
        print(insertUserStatementString)
        // Prepare the SQL statement
        if sqlite3_prepare_v2(DBManagerImpl.db, DBManagerImpl.insertUserStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            let username: NSString = user.username as NSString
            let password: NSString = user.password as NSString
            
            // Bind the values to the insert statement
            sqlite3_bind_text(insertStatement, 1, username.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, password.utf8String, -1, nil)
            
            // Execute the insert statement
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row into User.")
                status = true
            } else {
                let errmsg = String(cString: sqlite3_errmsg(DBManagerImpl.db))
                print("Failed to insert row into User: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(DBManagerImpl.db))
            print("Failed to prepare insert statement for User: \(errmsg)")
        }
        
        // Finalize the statement
        sqlite3_finalize(insertStatement)
        return status
    }
    
    static let checkUserPasswordStatementString = """
        SELECT password FROM User WHERE username = ?;
        """
    
    static func checkUser(username: String, password: String) -> Bool {
            var queryStatement: OpaquePointer?
            var isUserValid = false
            
            // Prepare the SQL statement
            if sqlite3_prepare_v2(DBManagerImpl.db, DBManagerImpl.checkUserPasswordStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                
                let username: NSString = username as NSString
                
                // Bind the username to the query statement
                sqlite3_bind_text(queryStatement, 1, username.utf8String, -1, nil)
                
                // Execute the query statement
                if sqlite3_step(queryStatement) == SQLITE_ROW {
                    // Retrieve the password from the result
                    if let queryResultCol1 = sqlite3_column_text(queryStatement, 0) {
                        let retrievedPassword = String(cString: queryResultCol1)
                        
                        // Check if the retrieved password matches the provided password
                        if retrievedPassword == password {
                            isUserValid = true
                        }
                    }
                } else {
                    print("User not found or password incorrect.")
                }
            } else {
                let errmsg = String(cString: sqlite3_errmsg(DBManagerImpl.db))
                print("Failed to prepare check user statement: \(errmsg)")
            }
            
            // Finalize the statement
            sqlite3_finalize(queryStatement)
            
            return isUserValid
        }
    
    
    static let queryStatementString = """
    SELECT a.*
    FROM FavoriteArticle fa
    JOIN Article a ON fa.ArticleURL = a.url
    WHERE fa.Username = ?;
    """
    
    static func query(username:String) -> [Article]{
        var queryStatement: OpaquePointer?
        var articles: [Article] = []
        // 1
        if sqlite3_prepare_v2(DBManagerImpl.db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            let username:NSString = username as NSString
            sqlite3_bind_text(queryStatement, 1, username.utf8String, -1, nil)
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
    
    
    
    static func deleteTable(table:String){
        // 1
        var deleteTableStatement: OpaquePointer?
        let deleteTableStatementString = "DROP TABLE \(table)"
        // 2
        if sqlite3_prepare_v2(DBManagerImpl.db, deleteTableStatementString, -1, &deleteTableStatement, nil) ==
            SQLITE_OK {
            // 3
            if sqlite3_step(deleteTableStatement) == SQLITE_DONE {
                print("\n\(table) table deleted.")
            } else {
                print("\n\(table) table is not deleted.")
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
    
    static  func deleteUserFavourite(url:String, user:String){
        let queryStatement = """
DELETE FROM FavoriteArticle WHERE ArticleUrl = "\(url)" AND Username = "\(user)";
"""
        let articleDelete = """
DELETE FROM Article
WHERE url = "\(url)" AND NOT EXISTS (
        SELECT 1 FROM FavoriteArticle WHERE ArticleUrl = "\(url)"
    );
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
        
        if sqlite3_prepare_v2(DBManagerImpl.db, articleDelete, -1, &deleteRowStatement, nil) ==
            SQLITE_OK {
            // 3
            if sqlite3_step(deleteRowStatement) == SQLITE_DONE {
                print("\nArticle deleted.")
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(DBManagerImpl.db))
                print("\n\(errorMessage)")
                print("\nArticle is not deleted.")
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
