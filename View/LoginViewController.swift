import UIKit
import FirebaseMessaging
class LoginViewController: UIViewController {    
    
    //MARK: - IBOutlet
    @IBOutlet weak var IDTxt: UITextField!
    @IBOutlet weak var PWDTxt: UITextField!
    @IBOutlet weak var LoginBtn: UIButton!
    
    var loginViewPresenter = LoginViewPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginViewPresenter.makeView(view: self)
        
        view.GradientColor(color1: UIColor(named: "MainYellowColor")!, color2: UIColor(named: "MainOrangeColor")!)
        
        IDTxtSetting()
        PWDTxtSetting()
        LoginBtnSetting()
    }
    // 화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // IDTxt 설정
    func IDTxtSetting() {
        IDTxt.layer.cornerRadius = 25
        IDTxt.layer.borderWidth = 2
        IDTxt.layer.borderColor = UIColor.white.cgColor
        IDTxt.setIcon(UIImage(named: "IDImage")!)
        IDTxt.attributedPlaceholder = NSAttributedString(string: "ID", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        IDTxt.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }
    // PWDTxt 설정
    func PWDTxtSetting() {
        PWDTxt.layer.cornerRadius = 25
        PWDTxt.layer.borderWidth = 2
        PWDTxt.layer.borderColor = UIColor.white.cgColor
        PWDTxt.setIcon(UIImage(named: "PWDImage")!)
        PWDTxt.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        PWDTxt.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }
    // LoginBtn 설정
    func LoginBtnSetting() {
        LoginBtn.layer.shadowColor = UIColor(named: "ShadowColor")!.cgColor
        LoginBtn.layer.cornerRadius = 25
        LoginBtn.layer.shadowOpacity = 1
        LoginBtn.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    // 키보드 up, down 설정(notification 활용) 노티피케이션 원리 이해하기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // keyboard up event 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:
                                                #selector(keyboardWillHideHandle), name:
                                                UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // keyboard up event 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        print("LoginVC - keyboardWillShowHandle called")
        
        // 키보드 사이즈 만큼 화면 올리기
        if let keyboardsize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardsize.height < LoginBtn.frame.origin.y {
                let distance = keyboardsize.height - LoginBtn.frame.origin.y + 170
                self.view.frame.origin.y = distance
            }
        }
    }
    
    @objc func keyboardWillHideHandle() {
        print("LoginVC - keyboardWillHideHandle called")
        self.view.frame.origin.y = 0
    }
    
    // MARK: - IBAction
    @IBAction func LoginBtnClicked(_ sender: Any) {
        loginViewPresenter.getId()
        loginViewPresenter.getPwd()
        loginViewPresenter.login()
    }
    
}
