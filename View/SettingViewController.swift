import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlet
    @IBOutlet weak var settingTableView: UITableView!
    
    let sql = Sql.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.title = "설정"
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        
        if indexPath.row == 0 { // 로그아웃 셀
            settingCell.settingLabel.text = "로그아웃"
            return settingCell
        }
        
        return settingCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            sql.deleteUserInfo()
            sql.deleteAllRoomInfos()
            sql.deleteAllRoomInNames()
            sql.deleteChatInfos()
            //        sql.updateUserInfoAutoLogin(autoLogin: 0)
            
            // 로그인 화면으로 이동 코드
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
}
