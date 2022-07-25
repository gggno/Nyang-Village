import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var MainTableView: UITableView!
    var cellArray: [MainTableViewCell] = []
    var roomInfos: [RoomInfos] = []
    
    var mainViewPresenter = MainViewPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.MainTableView.rowHeight = 80
        
        view.GradientColor(color1: UIColor(named: "MainYellowColor")!, color2: UIColor(named: "MainOrangeColor")!)
        
        tableBackgroundView.CornerRadiusLayerSetting(cornerRadius: 60, cornerLayer: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        MainTableView.delegate = self
        MainTableView.dataSource = self
        MainTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomInfos.count // 임시 코드
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        
        cell.SubjectNameLabel.text = roomInfos[indexPath.row].roomName
        cell.ProfessorNameLabel.text = roomInfos[indexPath.row].professorName
        
        cell.layer.cornerRadius = 50
        
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
        
    }
    
}
