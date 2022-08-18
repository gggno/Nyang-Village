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
            print("insertRoomInfo() data SuccessFully")
        } else {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("insertRoomInfo() fail :: \(errMsg)")
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
    func selectRoomInfo() -> [RoomInfoRow] {
        
        let selectQuery = "SELECT * FROM RoomInfo"
        var createTablePtr: OpaquePointer? = nil
        
        var roomInfoRowArr: [RoomInfoRow] = []
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing selectRoomInfo(): v1 \(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return roomInfoRowArr
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            let roomid = sqlite3_column_int(createTablePtr, 0)
            let roomName = String(cString: sqlite3_column_text(createTablePtr, 1))
            let nickName = String(cString: sqlite3_column_text(createTablePtr, 2))
            let professorName = String(cString: sqlite3_column_text(createTablePtr, 3))
            let position = sqlite3_column_int(createTablePtr, 4)
            let noti = sqlite3_column_int(createTablePtr, 5)
            
            let roomInfoRowST: RoomInfoRow = RoomInfoRow(roomId: Int(roomid), roomName: roomName, nickName: nickName, professorName: professorName, position: Int(position), noti: Int(noti))
            
            roomInfoRowArr.append(roomInfoRowST)
        }
        
        sqlite3_finalize(createTablePtr)
        
        return roomInfoRowArr
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
    func selectRoomInfoInNickname(roomid: Int) -> String {
        
        let selectQuery = "SELECT nickName FROM RoomInfo WHERE roomId=\(roomid)"
        var createTablePtr: OpaquePointer? = nil
        
        var nickName: String = ""
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing selectRoomInfoInNickname(): v1 \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return "실패!"
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            nickName = String(cString: sqlite3_column_text(createTablePtr, 0))
        }
        
        sqlite3_finalize(createTablePtr)
        
        return nickName
    }
    
    // 7. 마지막으로 읽은 채팅
    func selectRoomInfoPosition(roomid: Int) -> Int {
        
        let selectQuery = "SELECT position FROM RoomInfo WHERE roomId=\(roomid)"
        var createTablePtr: OpaquePointer? = nil
        
        var position: Int = 0
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing selectRoomInfoPosition(): v1 \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return position
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            position = Int(sqlite3_column_int(createTablePtr, 0))
        }
        
        sqlite3_finalize(createTablePtr)
        
        return position
    }
    
    // 8. 마지막으로 읽은 채팅위치 저장
    func updateRoomInfoPositon(positon: Int, roomid: Int) {
        
        let UpdateQuery = "UPDATE RoomInfo SET position=\(positon) WHERE roomId=\(roomid)"
        var createTablePtr: OpaquePointer? = nil
        
        if sqlite3_prepare(self.db, UpdateQuery, -1, &createTablePtr, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing updateRoomInfoPositon(): v1\(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_step(createTablePtr) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("updateRoomInfoPositon() fail :: \(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    // 9. fcm 알림
    func selectRoomInfoNoti(roomid: Int) -> NotiRoomInfo {
        
        let selectQuery = "SELECT roomName, noti FROM RoomInfo WHERE roomId=\(roomid)"
        var createTablePtr: OpaquePointer? = nil
        
        let roomName: String = ""
        let noti: Int = 0
        
        var notiRoomInfo: NotiRoomInfo = NotiRoomInfo(roomName: roomName, noti: noti)
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing selectRoomInfoNoti(): v1 \(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return notiRoomInfo
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            notiRoomInfo.roomName = String(cString: sqlite3_column_text(createTablePtr, 0))
            notiRoomInfo.noti = Int(sqlite3_column_int(createTablePtr, 1))
        }
        
        sqlite3_finalize(createTablePtr)
        
        return notiRoomInfo
    }
    
    // 10. fcm 알림2
    func selectRoomInfoNoti2(roomid: Int) -> Int {
        let selectQuery = "SELECT noti FROM RoomInfo WHERE roomId=\(roomid)"
        var createTablePtr: OpaquePointer? = nil
        
        var noti: Int = 0
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing selectRoomInfoNoti2(): v1 \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return noti
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            noti = Int(sqlite3_column_int(createTablePtr, 0))
        }
        
        sqlite3_finalize(createTablePtr)
        
        return noti
    }
    
    // 11. 알림 해제/허용
    func updateRoomInfoNoti(noti: Int, roomid: Int) {
        let UpdateQuery = "UPDATE RoomInfo SET noti=\(noti) WHERE roomId=\(roomid)"
        var createTablePtr: OpaquePointer? = nil
        
        if sqlite3_prepare(self.db, UpdateQuery, -1, &createTablePtr, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing updateRoomInfoNoti(): v1\(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_step(createTablePtr) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("updateRoomInfoNoti() fail :: \(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    // MARK: - UserInfo
    
    // 12. 유저정보저장
    func InsertUserInfo(studentid: String, token: String, suspendeddate: String, autologin: Int, jwt: String) {
        var createTablePtr : OpaquePointer? = nil
        
        let insertQeury: String = "INSERT INTO UserInfo (studentid, token, suspendeddate, autologin, jwt) VALUES (?,?,?,?,?);"
        
        if sqlite3_prepare(db, insertQeury, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing InsertUserInfo(): v1 \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        if sqlite3_bind_text(createTablePtr, 1, studentid, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_text(createTablePtr, 2, token, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_text(createTablePtr, 3, suspendeddate, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_int(createTablePtr, 4, Int32(autologin)) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_text(createTablePtr, 5, jwt, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_step(createTablePtr) == SQLITE_DONE {
            print("InsertUserInfo() data SuccessFully")
        } else {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("InsertUserInfo() fail :: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    // 13. 유저정보삭제
    func DeleteUserInfo() {
        
        
    }
    
    // 14. 유저정보 불러오기
    func SelectUserInfo() -> UserInfoRow {
        
        let selectQuery = "SELECT * FROM UserInfo LIMIT 1"
        var createTablePtr: OpaquePointer? = nil
        
        let studentId: String = ""
        let token: String = ""
        let suspendedDate: String = ""
        let autoLogin: Int = 0
        let jwt: String = ""
        
        var userInfo: UserInfoRow = UserInfoRow(studentId: studentId, token: token, suspendedDate: suspendedDate, autoLogin: autoLogin, jwt: jwt)
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing SelectUserInfo(): v1 \(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return userInfo
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            userInfo.studentId = String(cString: sqlite3_column_text(createTablePtr, 0))
            userInfo.token = String(cString: sqlite3_column_text(createTablePtr, 1))
            userInfo.suspendedDate = String(cString: sqlite3_column_text(createTablePtr, 2))
            userInfo.autoLogin = Int(sqlite3_column_int(createTablePtr, 3))
            userInfo.jwt = String(cString: sqlite3_column_text(createTablePtr, 4))
        }
        
        sqlite3_finalize(createTablePtr)
        
        return userInfo
    }
    
    // 15. 학번 가져오기
    func SelectUserInfoStudentId() {
        
        
    }
    
    // 16. 정지 풀리는 날짜
    func UpdateUserInfoSuspendedDate() {
        
        
    }
    
    // 17. jwt 교체
    func UpdateUserInfoJwt() {
        
        
    }
    
    // 18. 정지 날짜 가져오기
    func SelectUserInfoSuspendedDate() {
        
        
    }
    
    // 19. 토큰 가져오기
    func SelectUserInfoToken() {
        
        
    }
    
    // 20. 토큰 변경
    func UpdateUserInfoToken() {
        
        
    }
    
    // 21. 자동로그인 여부 가져오기
    func SelectUserInfoAutoLogin() -> Int {
        let selectQuery = "SELECT autoLogin FROM UserInfo LIMIT 1"
        var createTablePtr: OpaquePointer? = nil
        
        var autoLogin: Int = 0
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing SelectUserInfoAutoLogin(): v1 \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return autoLogin
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            autoLogin = Int(sqlite3_column_int(createTablePtr, 0))
        }
        
        sqlite3_finalize(createTablePtr)
        
        return autoLogin
    }
    
    // 22. 자동로그인 변경
    func UpdateUserInfoAutoLogin() {
        
        
    }
    
    // 23. 아이디 변경
    func UpdateUserInfoStudentId() {
        
        
    }
    
    // 24. jwt 가져오기
    func SelectUserInfoJwt() {
        
        
    }
    
    
    
    
    // MARK: - TestCaseSql(Delete)
    func deleteRoomInfo() {
        let deleteQuery = "DELETE FROM RoomInfo;"
        var createTablePtr: OpaquePointer? //query를 가리키는 포인터
        
        if sqlite3_prepare(db, deleteQuery, -1, &createTablePtr, nil) == SQLITE_OK{
            if sqlite3_step(createTablePtr) == SQLITE_DONE{
                print("\nDelete deleteRoomInfo() Row Success")
            }else{
                print("\nDelete deleteRoomInfo() Row Faild")
            }
        }else{
            print("\nDelete deleteRoomInfo() Statement in not prepared")
        }
        sqlite3_finalize(createTablePtr)
    }
    
    func deleteRoomInName() {
        let deleteQuery = "DELETE FROM RoomInName;"
        var createTablePtr: OpaquePointer? //query를 가리키는 포인터
        
        if sqlite3_prepare(db, deleteQuery, -1, &createTablePtr, nil) == SQLITE_OK{
            if sqlite3_step(createTablePtr) == SQLITE_DONE{
                print("\nDelete deleteRoomInName() Row Success")
            }else{
                print("\nDelete deleteRoomInName() Row Faild")
            }
        }else{
            print("\nDelete deleteRoomInName() Statement in not prepared")
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
