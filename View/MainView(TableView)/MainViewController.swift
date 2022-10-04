import UIKit

let pushNotificationName = "pushNotificationClicked"

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var MainTableView: UITableView!
    //    var cellArray: [MainTableViewCell] = []
    var roomInfos: [RoomInfos] = []
    var roomInfoDatas: [RoomInfoRow] = []
    
    var mainViewPresenter = MainViewPresenter()
    
    let sql = Sql.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushNotificationClicked(_:)), name: Notification.Name(pushNotificationName), object: nil)
        
        roomInfoData()
        // 테이블 뷰 높이
        self.MainTableView.rowHeight = 120
        
        // 테이블 뷰 라인 삭제
        self.MainTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        view.GradientColor(color1: UIColor(named: "MainYellowColor")!, color2: UIColor(named: "MainOrangeColor")!)
        
        // 테이블 뷰 뒤 뷰 cornerRadius 작업
        tableBackgroundView.CornerRadiusLayerSetting(cornerRadius: 60, cornerLayer: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        MainTableView.delegate = self
        MainTableView.dataSource = self
        MainTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if roomInfos.count > 0 { // 자동로그인이 아닐 때
            return roomInfos.count
        } else {
            return roomInfoDatas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        
        // 클릭 시 회색 하이라이트 제거
        cell.selectionStyle = .none
        
        if roomInfos.count > 0 { // 자동로그인 일 때
            
            cell.SubjectNameLabel.text = roomInfos[indexPath.row].roomName
            cell.ProfessorNameLabel.text = roomInfos[indexPath.row].professorName! + " 교수님"
            cell.NumberOfParticipantsLabel.text = String(roomInfos[indexPath.row].roomInNames!.count)
            
            return cell
        } else { // 자동로그인이 아닐 때
            
            cell.SubjectNameLabel.text = roomInfoDatas[indexPath.row].roomName
            cell.ProfessorNameLabel.text = roomInfoDatas[indexPath.row].professorName + " 교수"
            cell.NumberOfParticipantsLabel.text = String(roomInCount(roomid: roomInfoDatas[indexPath.row].roomId))
            return cell
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // 셀 클릭 시 채팅 화면으로 화면 전환
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChattingViewController") as! ChattingViewController
        
        if roomInfos.count > 0 { // 자동로그인이 아닐 때
            // 채팅방 별 타이틀(과목 명) 코드
            if let subjectName = roomInfos[indexPath.row].roomName {
                chatVC.title = subjectName
            }
            
            if let roomName = roomInfos[indexPath.row].roomName {
                chatVC.subjectName = "\(roomName)"                
            }
            if let professorName = roomInfos[indexPath.row].professorName {
                chatVC.professorName = "\(professorName)"
            }
            chatVC.roomId = roomInfos[indexPath.row].roomId
            
        } else { // 자동로그인 일 때
            chatVC.title = "\(roomInfoDatas[indexPath.row].roomName)"
            
            chatVC.subjectName = "\(roomInfoDatas[indexPath.row].roomName)"
            chatVC.professorName = "\(roomInfoDatas[indexPath.row].professorName)"
            chatVC.roomId = roomInfoDatas[indexPath.row].roomId
        }
        
        self.navigationController!.pushViewController(chatVC, animated: true)
    }
    
    func initCell(data: [RoomInfos]) {
        
        //        for roomData in data {
        //            let cell = MainTableViewCell()
        ////            cell.updateData(data: roomData)
        //            self.cellArray.append(cell)
        //        }
        self.roomInfos = data
        MainTableView.reloadData()
    }
    
    func prepareWithData(data: SubjectInfo) {
        // 프레젠터로
        mainViewPresenter.makeView(view: self, data: data)
        mainViewPresenter.roomDataBridge()
    }
    
    // sql로 roomInfo들의 데이터를 roomInfoDatas에 저장
    func roomInfoData() {
        roomInfoDatas = sql.selectRoomInfo()
    }
    
    // sql로 방 안에 사용자 수 불러오기
    func roomInCount(roomid: Int) -> Int {
        return sql.selectRoomInNames2(roomId: roomid).count
    }
    
    @IBAction func settingBtnClicked(_ sender: Any) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController")
        self.navigationController?.pushViewController(settingVC!, animated: true)
    }
    
    @objc func pushNotificationClicked(_ notification:Notification) {
        print("pushNotificationClicked() called")
        
        if let object = notification.object {
            
            let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChattingViewController") as! ChattingViewController
            
            if roomInfos.count > 0 { // 자동로그인이 아닐 때
                for cnt in 0...roomInfos.count-1 {
                    if roomInfos[cnt].roomId == object as! Int {
                        
                        if let subjectName = roomInfos[cnt].roomName {
                            chatVC.title = subjectName
                        }
                        
                        if let roomName = roomInfos[cnt].roomName {
                            chatVC.subjectName = "\(roomName)"
                        }
                        if let professorName = roomInfos[cnt].professorName {
                            chatVC.professorName = "\(professorName)"
                        }
                        chatVC.roomId = roomInfos[cnt].roomId
                        
                        break
                    }
                }
            } else { // 자동로그인 일때
                for cnt in 0...roomInfoDatas.count-1 { // 채팅방 개수만큼 반복문 돌림
                    if roomInfoDatas[cnt].roomId == object as! Int { // 알림 온 roomId랑 비교
                        chatVC.title = "\(roomInfoDatas[cnt].roomName)"
                        
                        chatVC.subjectName = "\(roomInfoDatas[cnt].roomName)"
                        chatVC.professorName = "\(roomInfoDatas[cnt].professorName)"
                        chatVC.roomId = roomInfoDatas[cnt].roomId
                        
                        break
                    }
                }
            }
            // 기존 스택에 쌓여있는 뷰 제거 -> 루트 뷰 재설정 -> 푸시
            self.navigationController!.pushViewController(chatVC, animated: true)
        }
        
    }
    
}
