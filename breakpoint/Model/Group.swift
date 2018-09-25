
import Foundation

class Group {
  
  private var _key: String
  private var _title: String
  private var _description: String
  private var _memberCount: Int
  private var _members: [String]
  
  var key: String {
    return _key
  }
  
  var title: String {
    return _title
  }
  
  var description: String {
    return _description
  }
  
  var memberCount: Int {
    return _memberCount
  }
  
  var members: [String] {
    return _members
  }
  
  init(key: String, title: String, description: String, members: [String]) {
    self._key = key
    self._title = title
    self._description = description
    self._memberCount = members.count
    self._members = members
  }
  
}
