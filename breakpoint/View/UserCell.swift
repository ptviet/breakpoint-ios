
import UIKit

class UserCell: UITableViewCell {
  
  // Outlets
  @IBOutlet weak var profileImg: UIImageView!
  @IBOutlet weak var emailLbl: UILabel!
  @IBOutlet weak var checkImg: UIImageView!
  
  // Variables
  var isShowing: Bool = false
  
  func configureCell(profileImage image: UIImage, email: String, isSelected: Bool) {
    self.profileImg.image = image
    self.emailLbl.text = email
    self.checkImg.isHidden = !isSelected
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    if selected {
      if isShowing == false {
        self.checkImg.isHidden = false
        isShowing = true
      } else {
        self.checkImg.isHidden = true
        isShowing = false
      }
    }
  }
  
}
