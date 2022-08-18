import Foundation

struct NotiRoomInfo {
    var roomName: String
    var noti: Int
    
    init(roomName: String, noti: Int) {
        self.roomName = roomName
        self.noti = noti
    }
}
