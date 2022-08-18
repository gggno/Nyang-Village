import Foundation

struct RoomInfoRow {
    var roomId: Int
    var roomName: String
    var nickName: String
    var professorName: String
    var positon: Int
    var noti: Int

    init(roomId: Int, roomName: String, nickName: String, professorName: String, position: Int, noti: Int) {
        self.roomId = roomId
        self.roomName = roomName
        self.nickName = nickName
        self.professorName = professorName
        self.positon = position
        self.noti = noti
    }
    
    func getRoomId() -> Int {
        return roomId
    }
    
    func getRoomName() -> String {
        return roomName
    }
    
    func getNickName() -> String {
        return nickName
    }
    
    func getProfessorName() -> String {
        return professorName
    }
    
    func getPosition() -> Int {
        return positon
    }
    
    func getNoti() -> Int {
        return noti
    }
}
