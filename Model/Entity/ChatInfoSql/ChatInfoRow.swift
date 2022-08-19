import Foundation

struct ChatInfoRow {
    
    var roomId: Int
    var nickName: String
    var time: String
    var content: String
    var type: Int
    
    init(roomId: Int, nickName: String, time: String, content: String, type: Int) {
        self.roomId = roomId
        self.nickName = nickName
        self.time = time
        self.content = content
        self.type = type
    }
    
}
