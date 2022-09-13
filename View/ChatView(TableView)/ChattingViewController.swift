import UIKit
import StompClientLib

class ChattingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StompClientLibDelegate {
    
    // SideMenuViewController에 데이터 전달을 위한 변수
    var subjectName: String?
    var professorName: String?
    var roomId: Int?
    
    let sql = Sql.shared
    
    // 소켓 클라이언트 생성
    var socketClient = StompClientLib()
    // 소켓 서버 주소
    let url = URL(string: "ws://13.209.68.42:8087/stomp")!
    
    // MARK: - IBOutlet
    @IBOutlet weak var chatView: UIView!
    
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var sendViewBottomMargin: NSLayoutConstraint!
    
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 소켓 연결
        registerSockect()
        
        view.GradientColor(color1: UIColor(named: "MainYellowColor")!, color2: UIColor(named: "MainOrangeColor")!)
        
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
        
        // 셀 등록
        chatTableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyTableViewCell")
        chatTableView.register(UINib(nibName: "YourTableViewCell", bundle: nil), forCellReuseIdentifier: "YourTableViewCell")
        chatTableView.register(UINib(nibName: "OutMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "OutMessageTableViewCell")
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
        
        sendViewBottomMargin.constant = height + 8 // sendView와 superView 간격이 8이라서 추가해줌.
        
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
        self.sendViewBottomMargin.constant = 8 // sendView와 superView 간격이 8이라서 추가해줌.
        
        // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 화면 터치 시 키보드 다운
    @objc func keyboardDownGesture(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 내 메세지 셀
        let myCell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        // 상대방 메세지 셀
        let yourCell = tableView.dequeueReusableCell(withIdentifier: "YourTableViewCell", for: indexPath) as! YourTableViewCell
        // 퇴장 메세지 셀
        let outMessageCell = tableView.dequeueReusableCell(withIdentifier: "OutMessageTableViewCell", for: indexPath) as! OutMessageTableViewCell
        
        // 클릭 시 회색 하이라이트 제거
        myCell.selectionStyle = .none
        yourCell.selectionStyle = .none
        outMessageCell.selectionStyle = .none
        
        return yourCell
    }
    
    // MARK: - IBAction
    @IBAction func sendBtnClicked(_ sender: Any) {
        
        guard let roomId = roomId else {
            return
        }
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH시 mm분"
        let time = formatter.string(from: now)
        
        var sendData: [String: Any] = ["roomId" : roomId, "nickName" : sql.selectRoomInfoInNickname(roomid: roomId), "content" : inputTextView.text, "time" : time, "type" : 2]
        
        socketClient.sendJSONForDict(dict: sendData as AnyObject, toDestination: "/pub/ay/chat")
        
        inputTextView.text = ""
    }
    
    @objc func sideBtnClicked() {
        let sideMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        
        sideMenuVC.subjectName = self.subjectName
        sideMenuVC.professorName = self.professorName
        sideMenuVC.roomId = self.roomId
        
        let menu = SideMenuNavigation(rootViewController: sideMenuVC)
        present(menu, animated: true, completion: nil)
    }
    
    // 구독 중인 토픽에서 Publish되면 실행되는 함수
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("stompClient() called")
        
        print("Destination : \(destination)")
        print("JSON Body : \(String(describing: jsonBody))")
        print("String Body : \(stringBody ?? "nil")")
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Stomp socket is disconnected")
        
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Stomp socket is connected")
        
        subscribe()
        chatRoomEntrance()
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error send : " + description)
        
        socketClient.disconnect()
        registerSockect()
    }
    
    func serverDidSendPing() {
        print("serverDidSendPing() called")
        
    }
    
    // Socket Connection
    func registerSockect() {
        socketClient.openSocketWithURLRequest(
            request: NSURLRequest(url: url),
            delegate: self,
            connectionHeaders: [ "jwt" : sql.selectUserInfoJwt()]
        )
        print("registerSockect() called")
    }
    
    func subscribe() {
        print("subscribe() called")
        
        guard let roomId = roomId else {
            return
        }
        socketClient.subscribe(destination: "/sub/chat/\(roomId)")
    }
    
    // Publish Message
    //    func sendMessage() {
    //        var payloadObject : [String : Any] = [ Key 1 : Value 1 , ... , Key N, Value N ]
    //
    //        socketClient.sendJSONForDict(
    //            dict: payloadObject as AnyObject,
    //            toDestination: "[publish prefix]/[publish url]")
    //    }
    
    // Unsubscribe
    func disconnect() {
        socketClient.disconnect()
    }
    
    // 채팅 방 입장할 때
    func chatRoomEntrance() {
        print("chatRoomEntrance() called")
        guard let roomId = roomId else {
            return
        }
        
        var entranceData: [String: Any] = ["roomId" : roomId, "studentId" : sql.selectUserInfoStudentId(), "token" : sql.selectUserInfoToken(), "version" : 1]
        
        socketClient.sendJSONForDict(dict: entranceData as AnyObject, toDestination: "/pub/ay/connectchat")
    }
    
}
