import UIKit

class ChattingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.GradientColor(color1: UIColor(named: "MainYellowColor")!, color2: UIColor(named: "MainOrangeColor")!)
        
        self.title = "냥빌리지 프로젝트 01반"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(rightBtnClicked))
        
        
    }
        
    @objc func rightBtnClicked() {
        print("click")
    }
    
}