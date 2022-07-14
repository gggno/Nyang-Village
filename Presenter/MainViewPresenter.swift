import Foundation
import UIKit

class MainViewPresenter {
    
    var mainViewModel = MainViewModel()
    var mainVC: MainViewController?
    
    func makeView(view: UIViewController, data: SubjectInfo) {
        self.mainVC = view as? MainViewController
        mainViewModel.setRoomInfos(allData: data)
    }
    
    func roomDataBridge() -> [RoomInfos] {
        return mainViewModel.roomDataSend()
    }
    
}
