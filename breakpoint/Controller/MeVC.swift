
import UIKit
import Firebase

class MeVC: UIViewController {
  
  //Outlets
  @IBOutlet weak var profileImg: UIImageView!
  @IBOutlet weak var emailLbl: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    emailLbl.text = Auth.auth().currentUser?.email
  }
  
  @IBAction func onSignOutBtnPressed(_ sender: Any) {
    let logoutPopup = UIAlertController(title: "_logout", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
    
    let logoutAction = UIAlertAction(title: "[logout]", style: .destructive) { (buttonTapped) in
      do {
        try Auth.auth().signOut()
        let authVC = self.storyboard?.instantiateViewController(withIdentifier: "authVC") as? AuthVC
        self.present(authVC!, animated: true, completion: nil)
      } catch {
        print(error)
      }
    }
    
    logoutPopup.addAction(logoutAction)
    present(logoutPopup, animated: true, completion: nil)
  }
  
}
