import UIKit
import StompClientLib

class ChattingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StompClientLibDelegate {
    
    // SideMenuViewController에 데이터 전달을 위한 변수
    var subjectName: String?
    var professorName: String?
    var roomId: Int?
    var nickName: String?
    var chatInfoDatas: [ChatInfoRow] = []
    
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
        
        chatInfoData()
        
        // 채팅방 별 닉네임 가져오기
        nickName = sql.selectRoomInfoInNickname(roomid: roomId!)
        
        view.GradientColor(color1: UIColor(named: "MainYellowColor")!, color2: UIColor(named: "MainOrangeColor")!)
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
//        self.navigationController?.navigationBar.backgroundColor = .black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(sideBtnClicked))
        
        // 테이블 뷰 라인 삭제
        self.chatTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // 테이블 뷰 터치 시 키보드 다운
        let tableViewDownGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardDownGesture(_:)))
        chatTableView.addGestureRecognizer(tableViewDownGestureRecognizer)
        
        // 채팅 셀 길게 터치
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(_:)))
        self.chatTableView.addGestureRecognizer(longPressGesture)
        
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
        chatTableView.register(UINib(nibName: "Type1TableViewCell", bundle: nil), forCellReuseIdentifier: "Type1TableViewCell")
        
        scrollToBottom()
    }
    
    // 채팅방 처음에 입장할 때 맨 아래(가장 최근 채팅)로 이동하는 함수
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatInfoDatas.count-1, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
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
        
        let indexPath = IndexPath(row: self.chatInfoDatas.count-1, section: 0)
        self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
    }
    
    // 키보드 내려갈 때 호출되는 메서드
    @objc func keyboardWillHideHandling(notification: NSNotification) {
        print("chattingVC - keyboardWillHideHandling() called")
        
        let notiInfo = notification.userInfo!

        self.sendViewBottomMargin.constant = 8 // sendView와 superView 간격이 8이라서 추가해줌.
        
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
  
//    override func viewWillAppear(_ animated: Bool) {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    @objc func keyboardUp(notification:NSNotification) {
//        print("up")
//        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//           let keyboardRectangle = keyboardFrame.cgRectValue
//
//            UIView.animate(
//                withDuration: 0.3
//                , animations: {
//                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
//                }
//            )
//        }
//    }
//    @objc func keyboardDown() {
//        print("down")
//        self.view.transform = .identity
//
//    }
    
    // 화면 터치 시 키보드 다운
    @objc func keyboardDownGesture(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // 셀 길게 클릭 시 신고 창 팝업
    @objc func longPressGestureRecognized(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            if let section = self.chatTableView.indexPathForRow(at: sender.location(in: self.chatTableView))?.section {
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
                feedbackGenerator.prepare()
                feedbackGenerator.impactOccurred()
                
                let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportPopUpViewController") as! ReportPopUpViewController
                
                // 백그라운드 투명도 처리
                reportVC.modalPresentationStyle = .overCurrentContext
                present(reportVC, animated: true)
            }
        }
    }
    
    // sql로 chatInfo들의 데이터를 chatInfoDatas에 저장
    func chatInfoData() {
        chatInfoDatas = sql.selectChatInfo(roomId: roomId!)
//        print("chatInfoDatas: \(chatInfoDatas)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatInfoDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 내 메세지 셀
        let myCell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        // 상대방 메세지 셀
        let yourCell = tableView.dequeueReusableCell(withIdentifier: "YourTableViewCell", for: indexPath) as! YourTableViewCell
        // type1 메세지 셀
        let type1Cell = tableView.dequeueReusableCell(withIdentifier: "Type1TableViewCell", for: indexPath) as! Type1TableViewCell
        
        // 클릭 시 회색 하이라이트 제거
        myCell.selectionStyle = .none
        yourCell.selectionStyle = .none
        type1Cell.selectionStyle = .none
        
        if chatInfoDatas[indexPath.row].type == 0 { // 상대방 메세지 셀 일 때
            yourCell.bubbleContentsLabel.text = chatInfoDatas[indexPath.row].content
            yourCell.nameLabel.text = chatInfoDatas[indexPath.row].nickName
            yourCell.timeLabel.text = chatInfoDatas[indexPath.row].time
            
            return yourCell
        } else if chatInfoDatas[indexPath.row].type == 1 { // 안내문 메세지(type1) 셀 일 때
            type1Cell.type1Label.text = chatInfoDatas[indexPath.row].content
            
            return type1Cell
        } else { // 내 메세지 일 때
            myCell.bubbleContentsLabel.text = chatInfoDatas[indexPath.row].content
            myCell.nameLabel.text = chatInfoDatas[indexPath.row].nickName
            myCell.timeLabel.text = chatInfoDatas[indexPath.row].time
            
            return myCell
        }
    }
    
    // MARK: - IBAction
    @IBAction func sendBtnClicked(_ sender: Any) {
        
        if inputTextView.text != "" { // inputTextView에 글자가 있을 때만 실행
            
            guard let roomId = roomId else {return}
            
            // 현재시간 구하기
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "a hh:mm"
            formatter.locale = Locale(identifier: "ko_KR")
            let time = formatter.string(from: now)
            
            let sendData: [String: Any] = ["roomId" : roomId, "nickName" : sql.selectRoomInfoInNickname(roomid: roomId), "content" : inputTextView.text, "time" : time, "type" : 2]
            sql.insertChatInfo(roomid: roomId, nickName: nickName!, time: time, content: inputTextView.text, type: 2)
            
            // 자신이 입력하여 전송버튼을 누르면 chatInfoDatas에 추가 되어 출력되는 코드
            let myCellDatas = ChatInfoRow(roomId: roomId, nickName: nickName!, time: time, content: inputTextView.text, type: 2)
            chatInfoDatas.append(myCellDatas)
            
            let lastIndexPath = IndexPath(row: chatInfoDatas.count - 1, section: 0)
            
            chatTableView.insertRows(at: [lastIndexPath], with: UITableView.RowAnimation.none)
            
            // 맨 아래로 스크롤 내리기
            chatTableView.scrollToRow(at: lastIndexPath, at: UITableView.ScrollPosition.bottom, animated: false)
            
            socketClient.sendJSONForDict(dict: sendData as AnyObject, toDestination: "/pub/ay/chat")
            
            inputTextView.text = ""
        }
        
    }
    
    @objc func sideBtnClicked() {
        let sideMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        
        sideMenuVC.subjectName = self.subjectName
        sideMenuVC.professorName = self.professorName
        sideMenuVC.roomId = self.roomId
        
        let menu = SideMenuNavigation(rootViewController: sideMenuVC)
        present(menu, animated: true, completion: nil)
    }
    
    
    
    // MARK: - stompFunc
    
    // 구독 중인 토픽에서 Publish되면 실행되는 함수. 모든 통신이 여기서 이루어짐.
    // 신고버튼을 누를 때(구현 예정)
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("stompClient() called")
        
        let jsonData = jsonBody as? [String : AnyObject]
        print("start: \(jsonData!["start"])")
        
        if jsonData!["start"] != nil { // 처음에 입장방 들어갈 때의 통신
            if jsonData!["start"] as! Int == 1 { // 이중로그인
                print("jsonData[start] 1 일때(이중로그인으로 인한 처리)")
                logoutAlert(title: "중복 로그인", message: "중복 로그인이 감지되어 해당 기기는 로그아웃 됩니다. ")
                
            } else if jsonData!["start"] as! Int == 2 { // 정지회원
                print("jsonData[start] 2 일때(정지회원으로 인한 처리)")
                logoutAlert(title: "정지 회원", message: "정지 회원입니다.")
                
            } else if jsonData!["start"] as! Int == 3 { // 새학기 시작
                print("jsonData[start] 3 일때(새학기 시작으로 인한 처리)")
                logoutAlert(title: "새 학기 시작", message: "새 학기 시작으로 인해 로그아웃 됩니다.")
            }
        }
        
        else {
            print("jsonData[start]이 nil 일때")
            
            if jsonData!["nickName"] as! String != nickName! {
                let type = jsonData!["type"]
                
                if type as! Int == 0 { // 입장할 때
                    print("type == 0 입장할 때") // jsonData["type"]이랑 type은 변수 명만 같고 다른 데이터 임
                    sql.insertRoomInName(roomid: roomId!, name: jsonData!["nickName"] as! String)
                    sql.insertChatInfo(roomid: roomId!, nickName: "", time: "", content: jsonData!["nickName"] as! String + "님이 들어왔습니다.", type: 1)
                    
                    // 셀 정보 저장
                    let type1CellDatas = ChatInfoRow(roomId: roomId!, nickName: jsonData!["nickName"] as! String, time: jsonData!["time"] as! String, content: jsonData!["content"] as! String, type: 1)
                    chatInfoDatas.append(type1CellDatas)
                    
                    // 테이블 뷰에 셀 추가
                    let lastIndexPath = IndexPath(row: chatInfoDatas.count - 1, section: 0)
                    chatTableView.insertRows(at: [lastIndexPath], with: UITableView.RowAnimation.none)
                    
                    let indexPath = IndexPath(row: self.chatInfoDatas.count-1, section: 0)
                    self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    
                } else if type as! Int == 1 { // 퇴장할 때
                    print("type == 1 퇴장할 때")
                    sql.deleteRoomInName(roomId: roomId!, name: jsonData!["nickName"] as! String)
                    sql.insertChatInfo(roomid: roomId!, nickName: "", time: "", content: jsonData!["nickName"] as! String + "님이 나갔습니다.", type: 1)
                    
                    // 셀 정보 저장
                    let type1CellDatas = ChatInfoRow(roomId: roomId!, nickName: jsonData!["nickName"] as! String, time: jsonData!["time"] as! String, content: jsonData!["content"] as! String, type: 1)
                    chatInfoDatas.append(type1CellDatas)
                    
                    // 테이블 뷰에 셀 추가
                    let lastIndexPath = IndexPath(row: chatInfoDatas.count - 1, section: 0)
                    chatTableView.insertRows(at: [lastIndexPath], with: UITableView.RowAnimation.none)
                    
                    let indexPath = IndexPath(row: self.chatInfoDatas.count-1, section: 0)
                    self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    
                } else { // 메세지 수신
                    print("else 메세지 수신")
                    sql.insertChatInfo(roomid: roomId!, nickName: jsonData!["nickName"] as! String, time: jsonData!["time"] as! String, content: jsonData!["content"] as! String, type: 0)
                    
                    // 셀 정보 저장
                    let yourCellDatas = ChatInfoRow(roomId: roomId!, nickName: jsonData!["nickName"] as! String, time: jsonData!["time"] as! String, content: jsonData!["content"] as! String, type: 0)
                    chatInfoDatas.append(yourCellDatas)
                    
                    // 테이블 뷰에 셀 추가
                    let lastIndexPath = IndexPath(row: chatInfoDatas.count - 1, section: 0)
                    chatTableView.insertRows(at: [lastIndexPath], with: UITableView.RowAnimation.none)
                    
                    let indexPath = IndexPath(row: self.chatInfoDatas.count-1, section: 0)
                    self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
        
//        print("Destination : \(destination)")
//        print("JSON Body : \(String(describing: jsonBody))")
//        print("String Body : \(stringBody ?? "nil")")
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
        
        guard let roomId = roomId else {return}
        socketClient.subscribe(destination: "/sub/chat/\(roomId)")
        ConnectChat.roomId = roomId
    }
    
    // Unsubscribe
    func disconnect() {
        socketClient.disconnect()
        ConnectChat.roomId = -1
    }
    
    // 채팅 방 입장할 때
    func chatRoomEntrance() {
        print("chatRoomEntrance() called")
        
        guard let roomId = roomId else {return}
        
        let entranceData: [String: Any] = ["roomId" : roomId, "studentId" : sql.selectUserInfoStudentId(), "token" : sql.selectUserInfoToken(), "version" : 1]
        
        socketClient.sendJSONForDict(dict: entranceData as AnyObject, toDestination: "/pub/ay/connectchat")
    }
    
    func chatRoomConfirm() {
        print("chatRoomConfirm() called")
        
        sql.deleteUserInfo()
        sql.deleteAllRoomInfos()
        sql.deleteAllRoomInNames()
        sql.deleteChatInfos()
        //        sql.updateUserInfoAutoLogin(autoLogin: 0)
        
        // 로그인 화면으로 이동 코드
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func logoutAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "확인", style: .default) {(_) in
            self.chatRoomConfirm()
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    deinit {
        print("ChattingViewController - deinit() called")
        NotificationCenter.default.removeObserver(self)
    }
    
}
