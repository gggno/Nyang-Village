import Foundation

struct LoginRequset: Encodable {
    
    var fcm: String
    var password: String
    var studentId: String
    var version: Int
    
    init(fcm: String, password: String, studentId: String, version: Int) {

        self.fcm = fcm
        self.password = password
        self.studentId = studentId
        self.version = version
    }
}
