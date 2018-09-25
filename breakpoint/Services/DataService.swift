
import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
  static let instance = DataService()
  
  private var _REF_BASE = DB_BASE
  private var _REF_USERS = DB_BASE.child("users")
  private var _REF_GROUPS = DB_BASE.child("groups")
  private var _REF_FEED = DB_BASE.child("feed")
  
  var REF_BASE: DatabaseReference { return _REF_BASE }
  var REF_USERS: DatabaseReference { return _REF_USERS }
  var REF_GROUPS: DatabaseReference { return _REF_GROUPS }
  var REF_FEED: DatabaseReference { return _REF_FEED }
  
  func createDBUser(uid: String, userData: Dictionary<String, Any>) {
    REF_USERS.child(uid).updateChildValues(userData)
    
  }
  
  func getUsername(forUID uid: String, completion: @escaping (_ username: String) -> ()) {
    REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
      guard let users = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
      for user in users {
        if user.key == uid {
          completion(user.childSnapshot(forPath: "email").value as! String)
        }
      }
    }
  }
  
  func uploadPost(withMessage massage: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
    
    if groupKey != nil {
      // Send to groups ref
    } else {
      // Pass into feed
      REF_FEED.childByAutoId().updateChildValues(["content" : massage, "senderId": uid])
      sendComplete(true)
    }
    
  }
  
  func getAllFeedMessages(completion: @escaping (_ messages: [Message]) -> ()) {
    var messageArray = [Message]()
    REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
      guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
      for message in feedMessageSnapshot {
        let content = message.childSnapshot(forPath: "content").value as! String
        let senderId = message.childSnapshot(forPath: "senderId").value as! String
        let message = Message(content: content, senderId: senderId)
        messageArray.append(message)
      }
      completion(messageArray)
    }
  }
  
  func getEmail(forSeachQuery query: String, completion: @escaping (_ emailArray: [String]) -> ()) {
    REF_USERS.observe(.value) { (userSnapshot) in
      guard let users = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
      var emailArray = [String]()
      for user in users {
        let email = user.childSnapshot(forPath: "email").value as! String
        if email.contains(query) == true && email != Auth.auth().currentUser?.email {
          emailArray.append(email)
        }
      }
      completion(emailArray)
    }
  }
  
  func getUserIds(forUsernames usernames: [String], completion: @escaping (_ uidArray: [String]) -> () ) {
    REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
      guard let users = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
      var idArray = [String]()
      for user in users {
        let email = user.childSnapshot(forPath: "email").value as! String
        if usernames.contains(email) {
          idArray.append(user.key)
        }
      }
      completion(idArray)
    }
  }
  
  func createGroup(withTitle title: String, andDesc desc: String, forUserIds ids: [String], completion: @escaping (_ groupCreated: Bool) -> ()) {
    REF_GROUPS.childByAutoId().updateChildValues(["title" : title, "description": desc, "members": ids])
    completion(true)
  }
  
}
