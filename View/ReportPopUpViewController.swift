import UIKit

class ReportPopUpViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var reportPopUpView: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var reportTextView: UITextView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.reportPopUpView.layer.cornerRadius = 15
        
        self.reportTextView.layer.cornerRadius = 5
        self.reportTextView.layer.borderWidth = 1
        self.reportTextView.layer.borderColor = UIColor(named: "MainOrangeColor")?.cgColor
        
        self.cancelBtn.layer.cornerRadius = 5
        self.cancelBtn.layer.borderWidth = 1
        self.cancelBtn.layer.borderColor = UIColor(named: "MainOrangeColor")?.cgColor
        
        self.sendBtn.layer.cornerRadius = 5
        self.sendBtn.layer.borderWidth = 1
        self.sendBtn.layer.borderColor = UIColor(named: "MainOrangeColor")?.cgColor
    }
    
    // MARK: - IBAction
    @IBAction func cancelBtnClicked(_ sender: Any) {
    }
    @IBAction func sendBtnClicked(_ sender: Any) {
    }
    

}
