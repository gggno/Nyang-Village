import UIKit

class Type1TableViewCell: UITableViewCell {

    @IBOutlet weak var type1Label: UILabel!
    
    @IBOutlet weak var type1BackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.type1BackgroundView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
