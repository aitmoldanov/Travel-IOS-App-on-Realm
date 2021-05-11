import Foundation
import RealmSwift

class Specimen: Object {
  @objc dynamic var name = ""
  @objc dynamic var specimenDescription = ""
  @objc dynamic var latitude = 0.0
  @objc dynamic var longitude = 0.0
  @objc dynamic var created = Date()
  
  @objc dynamic var category: Category!
}
