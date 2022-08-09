import Foundation
import SQLite3

class Sql {
    var db: OpaquePointer? = nil
    
    init() {
        self.db = createDB()
        
        createRoomInfoTable()
        createRoomInNameTable()
        createChatInfoTable()
        createUserInfoTable()
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
    
    // MARK: - RoomInfo
    
    // 방 정보 저장
    func insertRoomInfo(roomidInt: Int, roomnameStr: String, nicknameStr: String, professornameStr: String, positionInt: Int, notiInt: Int) {
        
        var createTablePtr : OpaquePointer? = nil
        
        let insertQeury: String = "INSERT INTO RoomInfo (roomid, roomname, nickname, professorname, position, noti) VALUES (?,?,?,?,?,?);"
        
        if sqlite3_prepare(db, insertQeury, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insertData(): v1 \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        if sqlite3_bind_int(createTablePtr, 1, Int32(roomidInt)) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_text(createTablePtr, 2, roomnameStr, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_text(createTablePtr, 3, nicknameStr, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_text(createTablePtr, 4, professornameStr, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_int(createTablePtr, 5, Int32(positionInt)) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_int(createTablePtr, 6, Int32(notiInt)) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_step(createTablePtr) == SQLITE_DONE {
            print("Insert data SuccessFully")
        } else {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("insert fail :: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    func deleteRoomInfos(roomids: [Int]) {
        let deleteQuery = "DELETE FROM RoomInfo WHERE roomid NOT IN \(roomids);"
        print("\(deleteQuery)")
        var createTablePtr: OpaquePointer? = nil//query를 가리키는 포인터
        
        if sqlite3_prepare(db, deleteQuery, -1, &createTablePtr, nil) == SQLITE_OK {
            if sqlite3_step(createTablePtr) == SQLITE_DONE {
                print("\nDelete RoomInfos Row Success")
            }else {
                print("\nDelete RoomInfos Row Faild")
            }
        }else {
            print("\nDelete RoomInfos Statement in not prepared")
        }
        sqlite3_finalize(createTablePtr)
    }
    
    func selectRoomInfo() {
        
        let selectQuery = "SELECT * FROM RoomInfo"
        
        var createTablePtr: OpaquePointer? = nil
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing selectValue(): v1 \(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
        
        
        
        
    }
    
    
    // MARK: - TestCaseSql(Delete)
    func deleteRoomInfo() {
        let deleteQuery = "DELETE FROM RoomInfo;"
        var createTablePtr: OpaquePointer? //query를 가리키는 포인터
        
        if sqlite3_prepare(db, deleteQuery, -1, &createTablePtr, nil) == SQLITE_OK{
            if sqlite3_step(createTablePtr) == SQLITE_DONE{
                print("\nDelete RoomInfo Row Success")
            }else{
                print("\nDelete RoomInfo Row Faild")
            }
        }else{
            print("\nDelete RoomInfo Statement in not prepared")
        }
        sqlite3_finalize(createTablePtr)
    }
    
    func deleteRoomInName() {
        let deleteQuery = "DELETE FROM RoomInName;"
        var createTablePtr: OpaquePointer? //query를 가리키는 포인터
        
        if sqlite3_prepare(db, deleteQuery, -1, &createTablePtr, nil) == SQLITE_OK{
            if sqlite3_step(createTablePtr) == SQLITE_DONE{
                print("\nDelete RoomInName Row Success")
            }else{
                print("\nDelete RoomInName Row Faild")
            }
        }else{
            print("\nDelete RoomInName Statement in not prepared")
        }
        sqlite3_finalize(createTablePtr)
    }
    
    func deleteChatInfo() {
        let deleteQuery = "DELETE FROM ChatInfo;"
        var createTablePtr: OpaquePointer? //query를 가리키는 포인터
        
        if sqlite3_prepare(db, deleteQuery, -1, &createTablePtr, nil) == SQLITE_OK{
            if sqlite3_step(createTablePtr) == SQLITE_DONE{
                print("\nDelete ChatInfo Row Success")
            }else{
                print("\nDelete ChatInfo Row Faild")
            }
        }else{
            print("\nDelete ChatInfo Statement in not prepared")
        }
        sqlite3_finalize(createTablePtr)
    }
    
    func deleteUserInfo() {
        let deleteQuery = "DELETE FROM UserInfo;"
        var createTablePtr: OpaquePointer? //query를 가리키는 포인터
        
        if sqlite3_prepare(db, deleteQuery, -1, &createTablePtr, nil) == SQLITE_OK{
            if sqlite3_step(createTablePtr) == SQLITE_DONE{
                print("\nDelete UserInfo Row Success")
            }else{
                print("\nDelete UserInfo Row Faild")
            }
        }else{
            print("\nDelete UserInfo Statement in not prepared")
        }
        sqlite3_finalize(createTablePtr)
    }
    
}
