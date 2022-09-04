import UIKit

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlet
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var professorNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.CornerRadiusLayerSetting(cornerRadius: 40, cornerLayer: [.layerMinXMinYCorner])
        
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        
        self.sideMenuTableView.rowHeight = 35
        self.sideMenuTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        sideMenuTableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sideMenuTableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath)
        
        return cell
    }
    
}
