
import UIKit
import Firebase

class CreatePostVC: UIViewController {
  
  // Outlets
  @IBOutlet weak var profileImg: UIImageView!
  @IBOutlet weak var emailLbl: UILabel!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var sendBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    spinner.isHidden = true
    textView.delegate = self
    sendBtn.bindToKeyboard()
    
    let toggleKeyboard = UITapGestureRecognizer(target: self, action: #selector(handleToggleKeyboard))
    view.addGestureRecognizer(toggleKeyboard)
  }
  
  @objc func handleToggleKeyboard() {
    view.endEditing(true)
  }
  
  @IBAction func onSendBtnPressed(_ sender: Any) {
    if textView.text != "" && textView.text != "Say something here..." {
      spinner.isHidden = false
      spinner.startAnimating()
      sendBtn.isEnabled = false
      DataService.instance.uploadPost(withMessage: textView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil) { (success) in
        if success {
          self.spinner.isHidden = true
          self.spinner.stopAnimating()
          self.sendBtn.isEnabled = true
          self.dismiss(animated: true, completion: nil)
        } else {
          debugPrint("Could not post.")
        }
        self.sendBtn.isEnabled = true
      }
    }

  }
  
  @IBAction func onCloseBtnPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
}

extension CreatePostVC: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    textView.text = ""
  }
  
}
