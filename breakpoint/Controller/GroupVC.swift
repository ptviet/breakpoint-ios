
import UIKit

class GroupVC: UIViewController {
  
  // Outlets
  @IBOutlet weak var tableView: UITableView!
  
  // Variables
  var groupArray = [Group]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
      DataService.instance.getAllGroups { (returnArray) in
        self.groupArray = returnArray
        self.tableView.reloadData()
      }
    }
    
  }
  
}

extension GroupVC: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groupArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell else { return GroupCell() }
    let group = groupArray[indexPath.row]
    cell.configureCell(title: group.title, desc: group.description, memberCount: group.memberCount)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "groupFeedVC") as? GroupFeedVC else { return }
    let group = groupArray[indexPath.row]
    groupFeedVC.iniData(forGroup: group)
    present(groupFeedVC, animated: true, completion: nil)
  }
  
}

