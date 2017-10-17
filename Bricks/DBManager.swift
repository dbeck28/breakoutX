//
//  DBManager.swift
//  Bricks
//
//  Created by Dayne Beck on 10/17/17.
//  Copyright © 2017 Dayne Beck. All rights reserved.
//

import UIKit

class DBManager: NSObject {
    // class to make singleton
    static let shared: DBManager = DBManager()
    
    let field_Users_UserID = "userID"
    let field_Users_UserName = "username"
    let field_Users_Email = "email"
    let field_Users_Password = "password"
    let field_Users_Tokens = "tokens"
    let field_Users_HighScore = "highscore"
    
    let databaseFileName = "bricksdatabase.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
   
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    func createDatabase() -> Bool {
        var created = false
        
            if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    let createUsersTable = "create table users (\(field_Users_UserID) integer primary key autoincrement not null, \(field_Users_UserName) text not null, \(field_Users_Email) text not null, \(field_Users_Password) text not null), \(field_Users_Tokens) integer not null, \(field_Users_HighScore) decimal not null"
                    
                    
                    do {
                        try database.executeUpdate(createUsersTable, values: nil)
                        created = true
                        print("dbcreated")
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    // At the end close the database.
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        return created
    }
}
