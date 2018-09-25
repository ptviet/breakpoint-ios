
import UIKit
import Firebase

class CreateGroupVC: UIViewController {
  
  // Outlets
  @IBOutlet weak var titleTxtField: InsetTextField!
  @IBOutlet weak var descTxtField: InsetTextField!
  @IBOutlet weak var emailSearchTxtField: InsetTextField!
  @IBOutlet weak var groupMemberLbl: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var submitBtn: UIButton!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var errorLbl: UILabel!
  
  // Variables
  var emailArray = [String]()
  var selectedUserArray = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    spinner.isHidden = true
    errorLbl.isHidden = true
    
    tableView.delegate = self
    tableView.dataSource = self
    
    emailSearchTxtField.delegate = self
    emailSearchTxtField.addTarget(self, action: #selector(onEmailSearchTxtFieldChanged), for: .editingChanged)

    let toggleKeyboard = UITapGestureRecognizer(target: self, action: #selector(handleToggleKeyboard))
    toggleKeyboard.cancelsTouchesInView = false
    
    view.addGestureRecognizer(toggleKeyboard)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    submitBtn.isHidden = true
    
  }
  
  @objc func handleToggleKeyboard() {
    view.endEditing(true)
  }
  
  @objc func onEmailSearchTxtFieldChanged() {
    if emailSearchTxtField.text == "" {
      emailArray = []
      tableView.reloadData()
    } else {
      DataService.instance.getEmail(forSeachQuery: emailSearchTxtField.text!) { (returnedEmailArray) in
        self.emailArray = returnedEmailArray
        self.tableView.reloadData()
      }
    }

  }
  
  @IBAction func onSubmitBtnPressed(_ sender: Any) {
    
    if titleTxtField.text != "" && descTxtField.text != "" {
      errorLbl.isHidden = true
      spinner.isHidden = false
      spinner.startAnimating()
      submitBtn.isEnabled = false
      
      DataService.instance.getUserIds(forUsernames: selectedUserArray) { (idArray) in
        var userIds = idArray
        userIds.append((Auth.auth().currentUser?.uid)!)
        DataService.instance.createGroup(withTitle: self.titleTxtField.text!, andDesc: self.descTxtField.text!, forUserIds: userIds, completion: { (success) in
          if success {
            self.errorLbl.isHidden = true
            self.dismiss(animated: true, completion: nil)
          } else {
            self.errorLbl.isHidden = false
            self.submitBtn.isEnabled = true
          }
          self.spinner.isHidden = true
          self.spinner.stopAnimating()
        })
      }
    } else {
      self.errorLbl.isHidden = false
    }
  }
  
  @IBAction func onCloseBtnPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
}

extension CreateGroupVC: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return emailArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserCell else { return UserCell() }
    let profileImg = UIImage(named: "defaultProfileImage")

    if selectedUserArray.contains(emailArray[indexPath.row]) {
      cell.configureCell(profileImage: profileImg!, email: emailArray[indexPath.row], isSelected: true)
    } else {
      cell.configureCell(profileImage: profileImg!, email: emailArray[indexPath.row], isSelected: false)
    }

    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
    if !selectedUserArray.contains(cell.emailLbl.text!) {
      selectedUserArray.append(cell.emailLbl.text!)
    } else {
      selectedUserArray = selectedUserArray.filter({ $0 != cell.emailLbl.text! })
    }
    
    if selectedUserArray.count > 0 {
      groupMemberLbl.text = selectedUserArray.joined(separator: ",")
      submitBtn.isHidden = false
    } else {
      groupMemberLbl.text = "add people to your group"
      submitBtn.isHidden = true
    }
  }
  
}

extension CreateGroupVC: UITextFieldDelegate {
  
}
