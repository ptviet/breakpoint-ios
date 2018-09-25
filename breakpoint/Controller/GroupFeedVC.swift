
import UIKit
import Firebase

class GroupFeedVC: UIViewController {
  
  // Outlets
  @IBOutlet var groupFeedView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var groupTitle: UILabel!
  @IBOutlet weak var membersLbl: UILabel!
  @IBOutlet weak var sendMsgView: UIView!
  @IBOutlet weak var messageTxtField: InsetTextField!
  @IBOutlet weak var sendMsgBtn: UIButton!
  
  // Variables
  var group: Group?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    groupFeedView.bindToKeyboard()
    
    let toggleKeyboard = UITapGestureRecognizer(target: self, action: #selector(handleToggleKeyboard))
    toggleKeyboard.cancelsTouchesInView = false
    
    view.addGestureRecognizer(toggleKeyboard)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    groupTitle.text = group?.title
    DataService.instance.getUserEmails(forGroup: group!) { (emailArray) in
      self.membersLbl.text = emailArray.joined(separator: ",")
    }

  }
  
  @objc func handleToggleKeyboard() {
    view.endEditing(true)
  }
  
  func iniData(forGroup group: Group) {
    self.group = group
  }
  
  @IBAction func onBackBtnPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func onSendMsgBtnPressed(_ sender: Any) {
    
    if messageTxtField.text != "" {

    }
    
  }
  

}
