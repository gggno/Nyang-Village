import Foundation
import Alamofire
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
    
    // 로그인 통신 함수
    func loginPost() {
        let url = "http://54.180.114.197:8087/ay/login"
        
        var loginRequest = LoginRequset(currentDate: dateSend(), fcm: fcmTokenSend(), password: <#T##String#>, studentId: <#T##String#>, version: 1)
        
        AF.request(url, method: .post, parameters: LoginRequset(currentDate: "20220625", fcm: "snfiwe1nkjn2i1", password: "rmsgh748596.", studentId: "2017E7035", version: 1), encoder: JSONParameterEncoder(), headers: nil).responseDecodable(of: SubjectInfo.self) { response in
            switch response.result {
            case .success(let response):
                print("Success!")
                self.didSuccess(response)
            case .failure(let error):
                print("Failure:", error)
            }
        }
        
    }
    
    func didSuccess(_ response: SubjectInfo) {
        
        let data = response.roomInfos![0].roomName
        print(data)
    }
    
}
