
import UIKit

class LoginVC: UIViewController {
  
  // Outlets
  @IBOutlet weak var emailTxtField: InsetTextField!
  @IBOutlet weak var passwordTxtField: InsetTextField!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var errorLbl: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    emailTxtField.delegate = self
    passwordTxtField.delegate = self
    spinner.isHidden = true
    errorLbl.isHidden = true
    errorLbl.text = ""
    
    let toggleKeyboard = UITapGestureRecognizer(target: self, action: #selector(handleToggleKeyboard))
    view.addGestureRecognizer(toggleKeyboard)
    
  }
  override func viewDidAppear(_ animated: Bool) {
    spinner.isHidden = true
    errorLbl.isHidden = true
    errorLbl.text = ""
  }
  
  @objc func handleToggleKeyboard() {
    view.endEditing(true)
  }
  
  @IBAction func onSignInSubmitBtnPressed(_ sender: Any) {
    if emailTxtField.text != nil && passwordTxtField.text != nil {
      errorLbl.isHidden = true
      spinner.isHidden = false
      spinner.startAnimating()
      AuthService.instance.loginUser(withEmail: emailTxtField.text!, andPassword: passwordTxtField.text!) { (success, error) in
        if success {
          self.dismiss(animated: true, completion: nil)
        } else {
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
              self.errorLbl.isHidden = false
              self.errorLbl.text = error?.localizedDescription
            }
            
          })
        }
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
      }
    } else {
      errorLbl.isHidden = false
      errorLbl.text = "_please check your input_"
    }
    
  }
  
  @IBAction func onCloseBtnPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
}

extension LoginVC: UITextFieldDelegate {
  
  
  
}
