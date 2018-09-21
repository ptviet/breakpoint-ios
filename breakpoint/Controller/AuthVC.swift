
import UIKit

class AuthVC: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func onSignInWithFacebookBtnPressed(_ sender: Any) {
    
  }
  
  @IBAction func onSignInWithGoogleBtnPressed(_ sender: Any) {
    
  }
  
  @IBAction func onSignInWithEmailBtnPressed(_ sender: Any) {
    let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginVC")
    present(loginVC!, animated: true, completion: nil)
    
  }
  
}
