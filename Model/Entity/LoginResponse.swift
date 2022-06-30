import Foundation

struct SubjectInfo: Decodable {
    var signal: Int?
    var suspendedDate: String?
    var roomInfos: [RoomInfos]?
    var jwt: String?
}

struct RoomInfos: Decodable {
    var roomName: String?
    var roomId: Int?
    var nickName: String?
    var professorName: String?
    var roomInNames: [String]?
}
