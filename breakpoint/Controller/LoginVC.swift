
import UIKit

class LoginVC: UIViewController {
  
  // Outlets
  @IBOutlet weak var emailTxtField: InsetTextField!
  @IBOutlet weak var passwordTxtField: InsetTextField!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    emailTxtField.delegate = self
    passwordTxtField.delegate = self
    spinner.isHidden = true
    
    let toggleKeyboard = UITapGestureRecognizer(target: self, action: #selector(handleToggleKeyboard))
    view.addGestureRecognizer(toggleKeyboard)
    
  }
  
  @objc func handleToggleKeyboard() {
    view.endEditing(true)
  }
  
  @IBAction func onSignInSubmitBtnPressed(_ sender: Any) {
    if emailTxtField.text != nil && passwordTxtField.text != nil {
      spinner.isHidden = false
      spinner.startAnimating()
      AuthService.instance.loginUser(withEmail: emailTxtField.text!, andPassword: passwordTxtField.text!) { (success, error) in
        if success {
          self.dismiss(animated: true, completion: nil)
        } else {
          debugPrint(String(describing: error?.localizedDescription))
        }
        AuthService.instance.registerUser(withEmail: self.emailTxtField.text!, andPassword: self.passwordTxtField.text!, registerComplete: { (success, error) in
          if success {
            AuthService.instance.loginUser(withEmail: self.emailTxtField.text!, andPassword: self.passwordTxtField.text!, loginComplete: { (success, error) in
              if success {
                self.dismiss(animated: true, completion: nil)
              } else {
                debugPrint(String(describing: error?.localizedDescription))
              }
            })
          } else {
            debugPrint(String(describing: error?.localizedDescription))
          }
          
        })
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
      }
    }
    
  }
  
  @IBAction func onCloseBtnPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
}

extension LoginVC: UITextFieldDelegate {
  
  
  
}
