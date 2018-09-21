
import Foundation
import Firebase

class AuthService {
  static let instance = AuthService()
  
  func registerUser(withEmail email: String, andPassword password: String, registerComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
    
    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
      guard let user = user else {
        registerComplete(false, error)
        return
      }
      
      let userData = ["provider": user.user.providerID, "email": user.user.email]
      DataService.instance.createDBUser(uid: user.user.uid, userData: userData as Dictionary<String, Any>)
      registerComplete(true, nil)
    }
  }
  
  func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
    
    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
      if error != nil {
        loginComplete(false, error)
        return
      }
      
      loginComplete(true, nil)
    }
  }
  
}
