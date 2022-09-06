import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var MainTableView: UITableView!
    //    var cellArray: [MainTableViewCell] = []
    var roomInfos: [RoomInfos] = []
    var roomInfoDatas: [RoomInfoRow] = []
    
    var completionHandler: ((String) -> (String))?
    
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
        } else {
            
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
            chatVC.subjectName = "\(roomInfos[indexPath.row].roomName)"
            chatVC.professorName = "\(roomInfos[indexPath.row].professorName)"
            
        } else { // 자동로그인 일 때
            chatVC.title = "\(roomInfoDatas[indexPath.row].roomName)"
            
            chatVC.subjectName = "\(roomInfoDatas[indexPath.row].roomName)"
            chatVC.professorName = "\(roomInfoDatas[indexPath.row].professorName)"
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
