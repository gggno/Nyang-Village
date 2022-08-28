import UIKit

class MyTableViewCell: UITableViewCell {

    // MARK: - IBAction
    @IBOutlet weak var bubbleBackgroundView: UIView!
    @IBOutlet weak var bubbleContentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.bubbleBackgroundView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
