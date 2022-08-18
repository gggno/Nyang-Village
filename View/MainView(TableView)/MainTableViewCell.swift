import UIKit

class MainTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var SubjectNameLabel: UILabel!
    @IBOutlet weak var ProfessorNameLabel: UILabel!
    @IBOutlet weak var NumberOfParticipantsLabel: UILabel!
    @IBOutlet weak var backBoardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backBoardView.layer.cornerRadius = 20
        backBoardView.layer.borderWidth = 0.2
        backBoardView.layer.borderColor = UIColor.gray.cgColor
        
        backBoardView.layer.shadowColor = UIColor.gray.cgColor
        backBoardView.layer.shadowOpacity = 0.5
        backBoardView.layer.shadowOffset = CGSize(width: 0, height: 5)
        // Configure the view for the selected state
    }
    
    func updateData(data: RoomInfos) {
        self.SubjectNameLabel.text = data.roomName
        self.ProfessorNameLabel.text = data.professorName
//        self.NumberOfParticipantsLabel.text = data.roomInNames?.count
    }

}
