import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var MainTableView: UITableView!
//    var cellArray: [MainTableViewCell] = []
    var roomInfos: [RoomInfos] = []
    
    var mainViewPresenter = MainViewPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        // 테이블 뷰 높이
        self.MainTableView.rowHeight = 100
        
        // 테이블 뷰 동적으로 높이 조절
//        self.MainTableView.estimatedRowHeight = 80
//        self.MainTableView.rowHeight = UITableView.automaticDimension
        
        // 테이블 뷰 라인 삭제
        self.MainTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        view.GradientColor(color1: UIColor(named: "MainYellowColor")!, color2: UIColor(named: "MainOrangeColor")!)
        
        tableBackgroundView.CornerRadiusLayerSetting(cornerRadius: 60, cornerLayer: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        MainTableView.delegate = self
        MainTableView.dataSource = self
        MainTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        
        // 클릭 시 회색 하이라이트 제거
        cell.selectionStyle = .none
        
        cell.SubjectNameLabel.text = roomInfos[indexPath.row].roomName
        cell.ProfessorNameLabel.text = roomInfos[indexPath.row].professorName! + " 교수님"
        cell.NumberOfParticipantsLabel.text = String(roomInfos[indexPath.row].roomInNames!.count)
        
        return cell
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
    
    @IBAction func settingBtnClicked(_ sender: Any) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController")
        self.navigationController?.pushViewController(settingVC!, animated: true)
    }
    
}
