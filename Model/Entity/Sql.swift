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
    
    // 1. 방 정보 저장
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
    
    // 2. 서버에서 받아 온 방 정보 리스트 저장
    func insertRoomInfos(subjectData: SubjectInfo) {
        for roomData in subjectData.roomInfos! {
            
            insertRoomInfo(roomidInt: roomData.roomId!, roomnameStr: roomData.roomName!, nicknameStr: roomData.nickName!, professornameStr: roomData.professorName!, positionInt: 0, notiInt: 1)
        }
    }
    
    // 3. 수강과목이 바뀌면 기존 과목은 삭제
    func deleteRoomInfos(roomids: String) {
        let deleteQuery = "DELETE FROM RoomInfo WHERE roomid NOT IN \(roomids);"
        
        var createTablePtr: OpaquePointer? = nil//query를 가리키는 포인터
        
        if sqlite3_prepare(db, deleteQuery, -1, &createTablePtr, nil) == SQLITE_OK {
            if sqlite3_step(createTablePtr) == SQLITE_DONE {
                print("\nDelete deleteRoomInfos() Row Success")
            } else {
                print("\nDelete deleteRoomInfos() Row Faild")
            }
        } else {
            print("\nDelete deleteRoomInfos() Statement in not prepared")
        }
        sqlite3_finalize(createTablePtr)
    }
    
    // 4. 방 정보 불러오기
    func selectRoomInfo() {
        
        let selectQuery = "SELECT * FROM RoomInfo"
        var createTablePtr: OpaquePointer? = nil
        
        var roomid: Int?
        var roomname: String?
        var nickName: String?
        var professorname: String?
        var position: Int?
        var noti: Int?
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing selectValue(): v1 \(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            
        }
        
        
    }
    
    // 5. 방 정보 전체 삭제
    func deleteAllRoomInfos() {
        let deleteQuery = "DELETE FROM RoomInfo;"
        
        var createTablePtr: OpaquePointer? = nil //query를 가리키는 포인터
        
        if sqlite3_prepare(db, deleteQuery, -1, &createTablePtr, nil) == SQLITE_OK {
            if sqlite3_step(createTablePtr) == SQLITE_DONE {
                print("\nDelete deleteAllRoomInfos() Row Success")
            } else {
                print("\nDelete deleteAllRoomInfos() Row Faild")
            }
        } else {
            print("\nDelete deleteAllRoomInfos() Statement in not prepared")
        }
        sqlite3_finalize(createTablePtr)
    }
    
    // 6. 웹에서 채팅 보낼 시 해당 기기에 내가 보낸 것으로 해야함
    func selectRoomInfoInNickname() {
        
    }
    
    // 7. 마지막으로 읽은 채팅
    func selectRoomInfoPosition() {
        
    }
    
    // 8. 마지막으로 읽은 채팅위치 저장
    func updateRoomInfoPositon() {
        
    }
    
    // 9. fcm 알림
    func selectRoomInfoNoti() {
        
    }
    
    // 10. fcm 알림2
    func selectRoomInfoNoti2() {
        
    }
    
    // 11. 알림 해제/허용
    func updateRoomInfoNoti() {
        
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
                print("\nDelete deleteChatInfo() Row Success")
            }else{
                print("\nDelete deleteChatInfo() Row Faild")
            }
        }else{
            print("\nDelete deleteChatInfo() Statement in not prepared")
        }
        sqlite3_finalize(createTablePtr)
    }
    
    func deleteUserInfo() {
        let deleteQuery = "DELETE FROM UserInfo;"
        var createTablePtr: OpaquePointer? //query를 가리키는 포인터
        
        if sqlite3_prepare(db, deleteQuery, -1, &createTablePtr, nil) == SQLITE_OK{
            if sqlite3_step(createTablePtr) == SQLITE_DONE{
                print("\nDelete deleteUserInfo() Row Success")
            }else{
                print("\nDelete deleteUserInfo() Row Faild")
            }
        }else{
            print("\nDelete deleteUserInfo() Statement in not prepared")
        }
        sqlite3_finalize(createTablePtr)
    }
    
}
