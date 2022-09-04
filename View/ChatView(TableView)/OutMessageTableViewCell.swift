import UIKit

class OutMessageTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var outMessageBackgroundView: UIView!
    @IBOutlet weak var outMessageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.outMessageBackgroundView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
