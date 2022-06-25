import Foundation
import UIKit

class MainViewPresenter: ViewUpdate {
    
    var mainViewModel = MainViewModel()
    var mainVC: MainViewController?
    
    func makeView(view: UIViewController) {
        self.mainVC = view as? MainViewController
    }
    
    
}

