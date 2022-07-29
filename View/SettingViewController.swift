import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
    @IBAction func backBtnCliked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
