import Foundation
import SQLite3

class Sql {
    var db: OpaquePointer? = nil
    
    init() {
        self.db = createDB()
    }
    
    // 디비 생성
    func createDB() -> OpaquePointer? {
        
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("NyangVillageTable.sqlite")
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("Error while creating db")
            return nil
        } else {
            print("Database has been created with path NyangVillageTableTable.sqlite")
            return db
        }
    }
    
    // 테이블 생성

    func createRoomInfoTable() {
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS RoomInfo (roomid INTEGER PRIMARY KEY, roomname TEXT, nickname TEXT, professorname TEXT, position INTEGER, noti INTEGER)"
        
        var createTablePtr: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, createTableQuery, -1, &createTablePtr, nil) == SQLITE_OK {
            
            if sqlite3_step(createTablePtr) == SQLITE_DONE {
                
                print("RoomInfoTable creation has been successfully done")
            }
            else {
                print("RoomInfoTable creation failure")
            }
        } else {
            print("Preparation for creating RoomInfoTable has been failed")
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    func createRoomInNameTable() {
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS RoomInName (id INTEGER PRIMARY KEY AUTOINCREMENT, roomid INTEGER REFERENCES RoomInfo(roomid) , name TEXT)"
        
        var createTablePtr: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, createTableQuery, -1, &createTablePtr, nil) == SQLITE_OK {
            
            if sqlite3_step(createTablePtr) == SQLITE_DONE {
                
                print("RoomInNameTable creation has been successfully done")
            }
            else {
                print("RoomInNameTable creation failure")
            }
        } else {
            print("Preparation for creating RoomInNameTable has been failed")
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    func createChatInfoTable() {
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS ChatInfo (id INTEGER PRIMARY KEY AUTOINCREMENT, roomid INTEGER REFERENCES RoomInfo(roomid), nickname TEXT, time TEXT, content TEXT, type INTEGER)"
        
        var createTablePtr: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, createTableQuery, -1, &createTablePtr, nil) == SQLITE_OK {
            
            if sqlite3_step(createTablePtr) == SQLITE_DONE {
                
                print("ChatInfoTable creation has been successfully done")
            }
            else {
                print("ChatInfoTable creation failure")
            }
        } else {
            print("Preparation for creating ChatInfoTable has been failed")
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    func createUserInfoTable() {
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS UserInfo (studentid TEXT PRIMARY KEY, token TEXT, suspendeddate TEXT, autologin INTEGER, jwt TEXT)"
        
        var createTablePtr: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, createTableQuery, -1, &createTablePtr, nil) == SQLITE_OK {
            
            if sqlite3_step(createTablePtr) == SQLITE_DONE {
                
                print("UserInfoTable creation has been successfully done")
            }
            else {
                print("UserInfoTable creation failure")
            }
        } else {
            print("Preparation for creating UserInfoTable has been failed")
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
}
