import UIKit

class MainTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var SubjectNameLabel: UILabel!
    @IBOutlet weak var ProfessorNameLabel: UILabel!
    @IBOutlet weak var NumberOfParticipantsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
