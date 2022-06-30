import Foundation

struct LoginRequest: Encodable {
    
    var fcm: String
    var password: String
    var studentId: String
    var version: Int
    
    init(fcm: String, password: String, studentId: String, version: Int) {

        self.fcm = fcm
        self.studentId = studentId
        self.password = password
        self.version = version
    }
}
