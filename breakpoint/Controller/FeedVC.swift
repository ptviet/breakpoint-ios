
import UIKit

class FeedVC: UIViewController {
  
  // Outlets
  @IBOutlet weak var tableView: UITableView!
  
  //Variables
  var messageArray = [Message]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DataService.instance.getAllFeedMessages { (returnMsgArray) in
      self.messageArray = returnMsgArray.reversed()
      self.tableView.reloadData()
    }
  }
  
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messageArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as? FeedCell else { return UITableViewCell() }
    let image = UIImage(named: "defaultProfileImage")
    let message = messageArray[indexPath.row]
    
    DataService.instance.getUsername(forUID: message.senderId) { (returnedUsername) in
      cell.configureCell(profileImg: image!, email: returnedUsername, message: message.content)
    }
    
    return cell
  }
  
}
