
import UIKit

class GroupCell: UITableViewCell {

  // Outlets
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var descLbl: UILabel!
  @IBOutlet weak var membersLbl: UILabel!
  
  func configureCell(title: String, desc: String, memberCount: Int) {
    self.titleLbl.text = title
    self.descLbl.text = desc
    self.membersLbl.text = memberCount > 1 ? "\(memberCount) members" : "\(memberCount) member"
  }

}
