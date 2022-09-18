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
        settingTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        
        return cell
    }
    
}
