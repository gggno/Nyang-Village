import UIKit

class ReportPopUpViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var reportPopUpView: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.reportPopUpView.layer.cornerRadius = 15
        self.reportView.CornerRadiusLayerSetting(cornerRadius: 15, cornerLayer: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        self.cancelBtn.layer.cornerRadius = 5
        self.cancelBtn.layer.borderWidth = 1
        self.cancelBtn.layer.borderColor = UIColor(named: "MainOrangeColor")?.cgColor
        
        self.sendBtn.layer.cornerRadius = 5
        self.sendBtn.layer.borderWidth = 1
        self.sendBtn.layer.borderColor = UIColor(named: "MainOrangeColor")?.cgColor
    }
    
    
    // MARK: - IBAction
    
    // 취소 버튼 클릭
    @IBAction func cancelBtnClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // 전송 버튼 클릭
    @IBAction func sendBtnClicked(_ sender: Any) {
        
    }
    

}
