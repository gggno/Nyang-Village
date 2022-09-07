import UIKit

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlet
    @IBOutlet weak var sideMenuTableView: UITableView!
   
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var professorNameLabel: UILabel!
   
    var subjectName: String?
    var professorName: String?
    
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
        
        
        sideMenuTableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sideMenuTableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        
        
        
        return cell
    }
    
}
