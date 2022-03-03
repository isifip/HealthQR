//
//  DatabaseManager.swift
//  HealthQR
//
//  Created by Irakli Sokhaneishvili on 26.02.22.
//

import Foundation
import GRDB

class DatabaseManager {
    var dbName: String!
    var databasePath: URL!
    var dbQueue: DatabaseQueue!
    
    static let sharedInstance: DatabaseManager = {
        let instance = DatabaseManager()
        
        return instance
    }()
    
    class func shared() -> DatabaseManager {
        return sharedInstance
    }
    
    func excludeFromBackup(url: URL) {
        var fileURL = url
        do {
            var res = URLResourceValues()
            res.isExcludedFromBackup = true
            try fileURL.setResourceValues(res)
        } catch {
            print("Error excluding \(url.absoluteString) from backup")
        }
    }
    
    func copyDB() -> Bool {
        var returnValue = false
        let fileName: NSString = dbName as NSString
        let ext = fileName.pathExtension
        let name = fileName.replacingOccurrences(of: ".\(ext)", with: "")
        
        do {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: databasePath.path) {
                if let dbFilePath = Bundle.main.path(forResource: name, ofType: ext) {
                    try fileManager.copyItem(atPath: dbFilePath, toPath: databasePath.path)
                    excludeFromBackup(url: databasePath)
                    returnValue = true
                } else {
                    returnValue = false
                    print("Oops - \(String(describing: dbName)) is not in the app bundle")
                }
            } else {
                returnValue = true
                print("Database file was found at path: \(databasePath.path)")
            }
        } catch {
            returnValue = false
            print("Something went wrong")
        }
        return returnValue
    }
    
    
    func openDB() -> Bool {
        var returnValue = false
        do {
            dbQueue = try DatabaseQueue(path: databasePath.absoluteString)
            returnValue = true
            
        } catch {
            returnValue = false
        }
        return returnValue
    }
    
    
    func checkAndloadDB(dbFileName: String) {
        dbName = dbFileName
        databasePath =  Common.getDocumentsDirectoryAppend(text: dbName)
        
        if (copyDB()) {
            if(!openDB()) {
                print("Error opening Database")
            } else {
                // upgrade the database if necessary
                print("Database opened successfully ")
            }
        } else {
            print("Error copying Database")
        }
    }
    
    func getVaccineByCVX(cvx: Int) -> Vaccine? {
        var retVal: Vaccine? = nil
        
        guard let dbQueue = dbQueue else { return retVal }
        
        do {
            try dbQueue.read{ db in
                if let row = try Row.fetchOne(db, sql: "SELECT * FROM vaccine WHERE cvx = ? ", arguments: [cvx]) {
                    retVal = Vaccine(id: row["id"], name: row["name"], description: row["description"], cvx: row["cvx"])
                }
            }
        }
        catch{
            print("Error getting vaccine from cvx: \(error)")
        }
        
        return retVal
    }
    
}
