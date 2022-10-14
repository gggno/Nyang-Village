import UIKit

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlet
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var professorNameLabel: UILabel!
    @IBOutlet weak var bellBtn: UIButton!
    
    var subjectName: String?
    var professorName: String?
    var roomId: Int?
    
    var roomInNames: [RoomInNamesRow] = []
    
    let sql = Sql.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.CornerRadiusLayerSetting(cornerRadius: 40, cornerLayer: [.layerMinXMinYCorner])
        
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        
        self.subjectNameLabel.text = subjectName
        self.professorNameLabel.text = professorName! + " 교수님"
        
        self.sideMenuTableView.rowHeight = 35
        self.sideMenuTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // 방 안에 사용자 불러오기
        roomInNames = sql.selectRoomInNames2(roomId: roomId!)
        
        sideMenuTableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("SideMenuViewController viewWillAppear() called")
        
        // if sql문에 노티가 1, 0 일때의 이미지 표현
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("SideMenuViewController viewWillDisappear() called")
        
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomInNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sideMenuTableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        cell.selectionStyle = .none
        
        cell.nameLabel.text = roomInNames[indexPath.row].name
        
        return cell
    }
    
    // 알림 이미지 클릭했을 때
    @IBAction func bellClicked(_ sender: Any) {
        print("bell clicked")
        
        // if 노티가 1이면 0(알림 허용 -> 해제) 1. sql문에 노티 변경 2. 벨 이미지 변경, 노티가 1이면 0(알림 해제 -> 허용) 1. sql문에 노티 변경 2. 벨 이미지 변경
        
        bellBtn.setImage(UIImage(systemName: "bell.slash.fill"), for: .normal)
    }
    
    
}
