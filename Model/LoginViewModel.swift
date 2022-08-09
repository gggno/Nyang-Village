import Foundation
import FirebaseMessaging
import Alamofire

class LoginViewModel {
    
    // fcm토큰 값 전달 함수
    func fcmTokenSend() -> String {
        guard let fcmToken = Messaging.messaging().fcmToken else { return "fcmtoken send fail"}
        return fcmToken
    }
    
    // 로그인 통신(post) api
    func loginTry(request: LoginRequest, completion: @escaping (SubjectInfo) -> Void) {
        
        let url = "http://13.209.68.42:8087/ay/login"
        
        AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder(), headers: nil).responseDecodable(of: SubjectInfo.self) { response in
            switch response.result {
            case .success(let response):
                print("Success!")
                
                // 정상 입력 되었을 때(signal == 4)
                if response.signal == 3 || response.signal == 4 {
                    completion(response)
                }
                // 아이디 또는 패스워드 잘못 입력했을 때(signal == 5)
                if response.signal == 5 {
                    completion(response)
                }
                
            case .failure(let error):
                print("Failure:", error)
            }
        }
    }
    
}
