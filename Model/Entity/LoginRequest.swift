import Foundation

struct LoginRequset: Encodable {
    
    var currentDate: String
    var fcm: String
    var password: String
    var studentId: String
    var version: Int
    
    init(currentDate: String, fcm: String, password: String, studentId: String, version: Int) {
        self.currentDate = currentDate
        self.fcm = fcm
        self.password = password
        self.studentId = studentId
        self.version = version
    }
}
