
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
  var groupMessages = [Message]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    groupFeedView.bindToKeyboard()
    tableView.delegate = self
    tableView.dataSource = self
    
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
    
    DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
      DataService.instance.getAllMessagesFor(theGroup: self.group!, completion: { (messageArray) in
        self.groupMessages = messageArray
        self.tableView.reloadData()
        if self.groupMessages.count > 0 {
          let endIndex = IndexPath.init(row: self.groupMessages.count - 1, section: 0)
          self.tableView.scrollToRow(at: endIndex, at: .none, animated: true)
        }
      })
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
      sendMsgBtn.isEnabled = false
      messageTxtField.isEnabled = false
      DataService.instance.uploadPost(withMessage: messageTxtField.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.key) { (success) in
        self.sendMsgBtn.isEnabled = true
        self.messageTxtField.text = ""
        self.messageTxtField.isEnabled = true
      }
    }
    
  }
  
}

extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groupMessages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as? GroupFeedCell else { return GroupFeedCell() }
    let message = groupMessages[indexPath.row]
    
    DataService.instance.getUsername(forUID: message.senderId) { (email) in
      cell.configureCell(profileImg: UIImage(named: "defaultProfileImage")!, email: email, content: message.content)
    }
    return cell
  }
  
  
}
