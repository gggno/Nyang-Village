import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var MainTableView: UITableView!
    //    var cellArray: [MainTableViewCell] = []
    var roomInfos: [RoomInfos] = []
    var roomInfoDatas: [RoomInfoRow] = []
    var roomId: Int? = nil
    var mainViewPresenter = MainViewPresenter()
    
    let sql = Sql.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if roomId != nil { // 푸시 알림을 클릭했을 때(roomId에 값이 있을 때)
            let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChattingViewController") as! ChattingViewController
            
            if roomInfos.count > 0 { // 자동로그인이 아닐 때
                for row in 0...roomInfos.count-1 {
                    if roomId == roomInfos[row].roomId {
                        print("최초 로그인일 때 푸시알림 클릭")
                    }
                }
            } else { // 자동로그인 일 때
                for row in 0...roomInfoDatas.count-1 {
                    if roomId == roomInfoDatas[row].roomId {
                        print("자동로그인 일 때 푸시알림 클릭")
                        chatVC.title = roomInfoDatas[row].roomName
                        print(chatVC.title!)
                        // 사이드 메뉴를 위해 채팅뷰로 데이터 전달
                        chatVC.subjectName = "\(roomInfoDatas[row].roomName)"
                        chatVC.professorName = "\(roomInfoDatas[row].professorName)"
                        chatVC.roomId = roomInfoDatas[row].roomId
                        
                        break
                    }
                }
            }
            self.navigationController!.pushViewController(chatVC, animated: true)
        }
        
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
        
        if roomInfos.count > 0 { // 자동로그인이 아닐 때
            
            cell.SubjectNameLabel.text = roomInfos[indexPath.row].roomName
            cell.ProfessorNameLabel.text = roomInfos[indexPath.row].professorName! + " 교수님"
            cell.NumberOfParticipantsLabel.text = String(roomInfos[indexPath.row].roomInNames!.count)
            
            return cell
        } else { // 자동로그인 일 때
            // sql에서 가져올 때 데이터가 뒤에서부터 들어오니까 역순으로 가져와야함
            let reverse = (roomInfoDatas.count - indexPath.row) - 1
            
            cell.SubjectNameLabel.text = roomInfoDatas[reverse].roomName
            cell.ProfessorNameLabel.text = roomInfoDatas[reverse].professorName + " 교수"
            cell.NumberOfParticipantsLabel.text = String(roomInCount(roomid: roomInfoDatas[reverse].roomId))
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
            
            // 사이드 메뉴를 위해 채팅뷰로 데이터 전달
            if let roomName = roomInfos[indexPath.row].roomName {
                chatVC.subjectName = "\(roomName)"                
            }
            if let professorName = roomInfos[indexPath.row].professorName {
                chatVC.professorName = "\(professorName)"
            }
            chatVC.roomId = roomInfos[indexPath.row].roomId
            
        } else { // 자동로그인 일 때
            let reverse = (roomInfoDatas.count - indexPath.row) - 1
            
            chatVC.title = "\(roomInfoDatas[reverse].roomName)"
            
            // 사이드 메뉴를 위해 채팅뷰로 데이터 전달
            chatVC.subjectName = "\(roomInfoDatas[reverse].roomName)"
            chatVC.professorName = "\(roomInfoDatas[reverse].professorName)"
            chatVC.roomId = roomInfoDatas[reverse].roomId
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
    
    
}
