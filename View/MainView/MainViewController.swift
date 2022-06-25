import UIKit
import FirebaseMessaging

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var MainTableView: UITableView!
    
    var mainViewPresenter = MainViewPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainViewPresenter.makeView(view: self)
        
        view.GradientColor(color1: UIColor(named: "MainYellowColor")!, color2: UIColor(named: "MainOrangeColor")!)
        
        tableBackgroundView.CornerRadiusLayerSetting(cornerRadius: 60, cornerLayer: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        MainTableView.delegate = self
        MainTableView.dataSource = self
        MainTableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTableViewCell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7 // 임시 코드
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath)
        cell.layer.cornerRadius = 50
        return cell
    }
    
    @IBAction func settingBtnClicked(_ sender: Any) {
        
    }
    
}
