import Foundation
import Alamofire
import UIKit

class LoginViewPresenter: ViewUpdate {
    
    var loginViewModel = LoginViewModel()
    var loginVC: LoginViewController?
    
    func makeView(view: UIViewController) {
        self.loginVC = view as? LoginViewController
    }
    
    // 로그인 통신 함수
    func loginTry() {
        
        let loginRequest = LoginRequset(currentDate: loginViewModel.dateSend(), fcm: loginViewModel.fcmTokenSend(), password: (loginVC?.PWDTxt.text)!, studentId: (loginVC?.IDTxt.text)!, version: 1)
        
        let url = "http://54.180.114.197:8087/ay/login"
        
        AF.request(url, method: .post, parameters: loginRequest, encoder: JSONParameterEncoder(), headers: nil).responseDecodable(of: SubjectInfo.self) { [self] response in
            switch response.result {
            case .success(let response):
                print("Success!")
                loginViewModel.didSuccess(response)
            case .failure(let error):
                print("Failure:", error)
            }
        }
    }
}
