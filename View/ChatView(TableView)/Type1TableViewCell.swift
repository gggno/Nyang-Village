import UIKit

class Type1TableViewCell: UITableViewCell {

    @IBOutlet weak var type1Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.type1Label.layer.cornerRadius = 30
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}