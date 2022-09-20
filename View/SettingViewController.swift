import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlet
    @IBOutlet weak var settingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.title = "설정"
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(UINib(nibName: "SettingLogoutTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingLogoutTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let logoutcell = tableView.dequeueReusableCell(withIdentifier: "SettingLogoutTableViewCell", for: indexPath) as! SettingLogoutTableViewCell
        
        if indexPath.row == 0 { // 로그아웃 셀
            return logoutcell
        }
        
        return logoutcell
    }
    
}
