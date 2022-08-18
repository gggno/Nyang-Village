import Foundation

struct UserInfoRow {
    
    var studentId: String
    var token: String
    var suspendedDate: String
    var autoLogin: Int
    var jwt: String
    
    init(studentId: String, token: String, suspendedDate: String, autoLogin: Int, jwt: String) {
        self.studentId = studentId
        self.token = token
        self.suspendedDate = suspendedDate
        self.autoLogin = autoLogin
        self.jwt = jwt
    }
    
}
