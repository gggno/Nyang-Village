import UIKit
import SQLite3
import SystemConfiguration

class ReportPopUpViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var reportPopUpView: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    
    var completionHandler: (() -> Void)?
    
    let sql = Sql.shared
    
    var reportNickName: String? // 신고대상 닉네임
    var reportContent: String? // 신고대상이 보낸 채팅 메시지
    var reportWhy: String? // 신고사유
    var reporterNickname: String? // 신고자 닉네임
    var studentId: String? // 신고자 학번
    var roomName: String? // 과목명
    var professorName: String? // 교수이름
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        studentId = sql.selectUserInfoStudentId()

        self.nickNameLabel.text = reportNickName!
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
        print("sendBtnClicked")
        
        if let completionHandler = completionHandler {
            completionHandler()
            dismiss(animated: true)
        }
    }

}
