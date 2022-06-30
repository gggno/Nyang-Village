import Foundation
import Alamofire
import UIKit

class LoginViewPresenter: ViewUpdate, getAccount {
    
    // 모델과 뷰를 가지고 있음(연결해주는 중간다리 역할)
    var loginViewModel = LoginViewModel()
    var loginVC: LoginViewController?
    
    func makeView(view: UIViewController) {
        self.loginVC = view as? LoginViewController
    }
    
    func getId() -> String {
        let id: String
        id = (loginVC?.IDTxt.text)!
        
        return id
    }
    
    func getPwd() -> String {
        let pwd: String
        pwd = (loginVC?.PWDTxt.text)!
        
        return pwd
    }
    
    func getToken() -> String {
        let token: String
        token = loginViewModel.fcmTokenSend()
        
        return token
    }
    
    func login(requestData: LoginRequest) {
        loginViewModel.loginTry(request: requestData)
    }
    
}
