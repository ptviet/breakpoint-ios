
import UIKit

class FeedCell: UITableViewCell {
  
  // Outlets
  @IBOutlet weak var profileImg: UIImageView!
  @IBOutlet weak var emailLbl: UILabel!
  @IBOutlet weak var messageContentLbl: UILabel!
  
  func configureCell(profileImg: UIImage, email: String, message: String) {
    self.profileImg.image = profileImg
    self.emailLbl.text = email
    self.messageContentLbl.text = message
  }

}
