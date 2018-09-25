
import UIKit
import Firebase

class AuthVC: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if Auth.auth().currentUser != nil {
      dismiss(animated: true, completion: nil)
    }
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
