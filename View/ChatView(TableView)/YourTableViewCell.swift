import UIKit

class YourTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet weak var bubbleBackgroundView: UIView!
    @IBOutlet weak var bubbleContentsLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bubbleBackgroundView.layer.cornerRadius = 13
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
