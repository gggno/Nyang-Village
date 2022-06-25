import Foundation
import FirebaseMessaging

class LoginViewModel {
    
    // 현재 날짜 전달 함수
    func dateSend() -> String {
        let date = DateFormatter()
        date.dateFormat = "yyMMdd"
        
        return date.string(from: Date.now)
    }
     // fcm토큰 값 전달 함수
    func fcmTokenSend() -> String {
        guard let fcmToken = Messaging.messaging().fcmToken else { return "fcmtoken send fail"}
        return fcmToken
    }
    // 지금은 확인 차 임시 코드 작성함
    func didSuccess(_ response: SubjectInfo) {
        
        let data = response.roomInfos![0].roomName
        print(data)
    }
    
}
