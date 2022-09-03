import UIKit

class ChattingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlet
    @IBOutlet weak var chatView: UIView!
    
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var sendViewBottomMargin: NSLayoutConstraint!
    
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.GradientColor(color1: UIColor(named: "MainYellowColor")!, color2: UIColor(named: "MainOrangeColor")!)
        
        self.title = "냥빌리지 프로젝트 01반"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(sideBtnClicked))
        
        // 테이블 뷰 라인 삭제
        self.chatTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // 테이블 뷰 터치 시 키보드 다운
        let tableViewDownGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardDownGesture(_:)))
        chatTableView.addGestureRecognizer(tableViewDownGestureRecognizer)
        
        chatView.CornerRadiusLayerSetting(cornerRadius: 40, cornerLayer: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        // 입력 칸 설정
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.borderColor = UIColor(named: "ShadowColor")!.cgColor
        inputTextView.layer.cornerRadius = 10
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyTableViewCell")
        chatTableView.register(UINib(nibName: "YourTableViewCell", bundle: nil), forCellReuseIdentifier: "YourTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("chattingVC viewWillAppear() called")
        
        // 키보드 노티피케이션 등록
        // 키보드가 올라오는 것을 관찰(감지) -> 키보드가 올라오면 selector에 있는 함수(keyboardWillShowHandling())가 발동
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandling(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //키보드가 내려가는 것을 관찰(감지) -> 키보드가 내려가면 selector에 있는 함수(keyboardWillHideHandling())가 발동
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandling(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("chattingVC viewWillDisAppear() called")
        
        // 노티피케이션 연결 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self)
    }
    
    // 키보드 올라갈 때 호출되는 메서드
    @objc func keyboardWillShowHandling(notification: NSNotification) {
        print("chattingVC - keyboardWillShowHandling() called")
        
        let notiInfo = notification.userInfo!
        
        // 키보드 높이를 가져옴
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let height = keyboardFrame.size.height - self.view.safeAreaInsets.bottom
        
        sendViewBottomMargin.constant = height + 0 // sendView와 superView 간격이 34라서 추가해줌.
        
        // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 키보드 내려갈 때 호출되는 메서드
    @objc func keyboardWillHideHandling(notification: NSNotification) {
        print("chattingVC - keyboardWillHideHandling() called")
        
        let notiInfo = notification.userInfo!
        
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        self.sendViewBottomMargin.constant = 0 // sendView와 superView 간격이 34라서 추가해줌.
        
        // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath)
        let yourCell = tableView.dequeueReusableCell(withIdentifier: "YourTableViewCell", for: indexPath)
        
        // 클릭 시 회색 하이라이트 제거
        myCell.selectionStyle = .none
        yourCell.selectionStyle = .none
        
        return yourCell
    }
    
    // MARK: - IBAction
    @objc func sideBtnClicked() {
        print("click")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sideMenuVC: SideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        let menu = SideMenuNavigation(rootViewController: sideMenuVC)
        present(menu, animated: true, completion: nil)
    }
    
    @IBAction func sendBtnClicked(_ sender: Any) {
        
        
    }
    
    // 화면 터치 시 키보드 다운
    @objc func keyboardDownGesture(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
        
}
