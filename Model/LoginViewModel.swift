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
        
        let url = "http://54.180.114.197:8087/ay/login"
        
        AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder(), headers: nil).responseDecodable(of: SubjectInfo.self) { response in
            switch response.result {
            case .success(let response):
                print("Success!")
                
                completion(response)
                
                // didSuccess(response)
            case .failure(let error):
                print("Failure:", error)
            }
        }
    }
    
    // 통신 성공 시 수행되는 함수
    func didSuccess(_ completion: @escaping (SubjectInfo) -> Void) {
        
//        let data = response.roomInfos![0].roomName
//        print(data)
        
    }
    
}
