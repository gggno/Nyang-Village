import Foundation
import FirebaseMessaging
import Alamofire

class LoginViewModel {
    
    // fcm토큰 값 전달 함수
    func fcmTokenSend() -> String {
        guard let fcmToken = Messaging.messaging().fcmToken else { return "fcmtoken send fail"}
        return fcmToken
    }
    // 지금은 확인 차 임시 코드 작성함
    func didSuccess(_ response: SubjectInfo) {
        
        let data = response.roomInfos![1].roomName
        print(data)
    }
    
    // 로그인 통신(post) api 
    func loginTry(request: LoginRequest) {
        
        let url = "http://54.180.114.197:8087/ay/login"
        
        AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder(), headers: nil).responseDecodable(of: SubjectInfo.self) { [self] response in
            switch response.result {
            case .success(let response):
                print("Success!")
                didSuccess(response)
            case .failure(let error):
                print("Failure:", error)
            }
        }
    }
    
}
