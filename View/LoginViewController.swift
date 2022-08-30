import UIKit
import FirebaseMessaging

class LoginViewController: UIViewController {    
    
    //MARK: - IBOutlet
    @IBOutlet weak var IDTxt: UITextField!
    @IBOutlet weak var PWDTxt: UITextField!
    @IBOutlet weak var LoginBtn: UIButton!
    
    var loginViewPresenter = LoginViewPresenter()

    var sql = Sql.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SQL 테스트 용
//        forTheSqlTest()
        
        // 자동 로그인 로직
        if sql.selectUserInfoAutoLogin() == 1 {
            
            // 루트 뷰 변경
            
            
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
            self.navigationController?.pushViewController(mainVC!, animated: true)
            
            print("자동로그인 성공")
        } else {
            print("자동로그인 실패")
        }
        
        loginViewPresenter.makeView(view: self)
        
        view.GradientColor(color1: UIColor(named: "MainYellowColor")!, color2: UIColor(named: "MainOrangeColor")!)
        
        IDTxtSetting()
        PWDTxtSetting()
        LoginBtnSetting()
        
        self.view.addSubview(activityIndicator)
    }
    
    func forTheSqlTest() {
        sql.deleteRoomInfoTest()
        sql.deleteRoomInNameTest()
        sql.deleteChatInfoTest()
        sql.deleteUserInfoTest()
    }
    
    // 화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 로딩 인디케이터
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.style = .large
        
        return activityIndicator
    }()
    
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
        activityIndicator.startAnimating()
        loginViewPresenter.login(requestData: LoginRequest(fcm: loginViewPresenter.getToken(), password: loginViewPresenter.getPwd(), studentId: loginViewPresenter.getId(), version: 1), completion2: { result in
            // 로그인 signal 구분지어서 코드 재작성 해야 됨.
            if result.signal == 1 { // 앱 업데이트
                self.activityIndicator.stopAnimating()
                let alert = UIAlertController(title: "업데이트", message: "업데이트 후 이용해주세요.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(ok)
                self.present(alert, animated: true)
            } else if result.signal == 3 { // 최초 로그인(정상 입력)
                self.navigationController?.pushViewController(animated: true, viewName: "MainViewController", completion: { vc in
                    
                    // 사용자 정보를 내부 db에 저장
                    self.sql.insertUserInfo(studentid: self.loginViewPresenter.getId(), token: self.loginViewPresenter.getToken(), suspendeddate: result.suspendedDate ?? "noData", autologin: 1, jwt: result.jwt!)
                    // 사용자 수강 과목 정보를 내부 db에 저장
                    self.sql.insertRoomInfos(subjectData: result)
                    self.sql.insertRoomInNames(subjectData: result)
                    
                    self.activityIndicator.stopAnimating()
                    let main = vc as! MainViewController
                    
                    main.prepareWithData(data: result)
                })
            } else if result.signal == 4 { // 기존 로그인 기록 남아있을 때(정상 입력)
                self.navigationController?.pushViewController(animated: true, viewName: "MainViewController", completion: { vc in
                    
                    // 사용자 정보를 내부 db에 저장
                    self.sql.insertUserInfo(studentid: self.loginViewPresenter.getId(), token: self.loginViewPresenter.getToken(), suspendeddate: result.suspendedDate ?? "noData", autologin: 1, jwt: result.jwt!)
                   
                    // 사용자 수강 과목 정보를 내부 db에 저장
                    self.sql.insertRoomInfos(subjectData: result)
                    self.sql.insertRoomInNames(subjectData: result)
                    
                    // 수강 정정 시 변경된 과목 삭제
                    var roomArr: [Int] = []
                    for cnt in 0...result.roomInfos!.count-1 {
                        roomArr.append(result.roomInfos![cnt].roomId!)
                    }
                    let convertNum = roomArr.map{ "\($0)" }
                    let convertResult = "(\(convertNum.joined(separator: ",")))"
                    
                    self.sql.deleteRoomInfos(roomids: convertResult)
                    
                    self.activityIndicator.stopAnimating()
                    let main = vc as! MainViewController
                    
                    main.prepareWithData(data: result)
                })
                
            } else if result.signal == 5 { //아이디 또는 패스워드 잘못 입력했을 때
                self.activityIndicator.stopAnimating()
                let alert = UIAlertController(title: "로그인 실패", message: "아이디 또는 비밀번호를 확인해주세요.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(ok)
                self.present(alert, animated: true)
                
            } else if result.signal == 6 { // 정지된 회원
                self.activityIndicator.stopAnimating()
                let alert = UIAlertController(title: "이용 제한 계정", message: "정지된 계정입니다.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
            
        })
        
    }
    
}
