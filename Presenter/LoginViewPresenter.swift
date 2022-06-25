import Foundation
import UIKit

class LoginViewPresenter: ViewUpdate {
        
    var loginViewModel = LoginViewModel()
    var loginVC: LoginViewController?
    
    func makeView(view: UIViewController) {
        self.loginVC = view as? LoginViewController
    }
    
    
}
