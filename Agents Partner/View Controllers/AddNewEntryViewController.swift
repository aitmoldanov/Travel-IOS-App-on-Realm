
import RealmSwift
import UIKit

//
// MARK: - Add New Entry View Controller
//
class AddNewEntryViewController: UIViewController {
  @IBOutlet weak var categoryTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextView!
  @IBOutlet weak var nameTextField: UITextField!
  
  //
  // MARK: - Variables And Properties
  //
  var selectedAnnotation: SpecimenAnnotation!
  var selectedCategory: Category!
  var specimen: Specimen!
  
  //
  // MARK: - IBActions
  //
  @IBAction func unwindFromCategories(segue: UIStoryboardSegue) {
    if segue.identifier == "CategorySelectedSegue" {
      let categoriesController = segue.source as! CategoriesTableViewController
      selectedCategory = categoriesController.selectedCategory
      categoryTextField.text = selectedCategory.name
    }
  }
  
  //
  // MARK: - Private Methods
  //
  func addNewSpecimen() {
    let realm = try! Realm() // 1
    
    try! realm.write { // 2
      let newSpecimen = Specimen() // 3
      
      newSpecimen.name = nameTextField.text! // 4
      newSpecimen.category = selectedCategory
      newSpecimen.specimenDescription = descriptionTextField.text
      newSpecimen.latitude = selectedAnnotation.coordinate.latitude
      newSpecimen.longitude = selectedAnnotation.coordinate.longitude
      
      realm.add(newSpecimen) // 5
      specimen = newSpecimen // 6
    }
  }
  
  func fillTextFields() {
    nameTextField.text = specimen.name
    categoryTextField.text = specimen.category.name
    descriptionTextField.text = specimen.specimenDescription
    
    selectedCategory = specimen.category
  }
  
  func updateSpecimen() {
    let realm = try! Realm()
    
    try! realm.write {
      specimen.name = nameTextField.text!
      specimen.category = selectedCategory
      specimen.specimenDescription = descriptionTextField.text
    }
  }
  
  func validateFields() -> Bool {
    if nameTextField.text!.isEmpty || descriptionTextField.text!.isEmpty || selectedCategory == nil {
      let alertController = UIAlertController(title: "Validation Error",
                                              message: "All fields must be filled",
                                              preferredStyle: .alert)
      
      let alertAction = UIAlertAction(title: "OK", style: .destructive) { alert in
        alertController.dismiss(animated: true, completion: nil)
      }
      
      alertController.addAction(alertAction)
      
      present(alertController, animated: true, completion: nil)
      
      return false
    } else {
      return true
    }
  }
  
  //
  // MARK: - View Controller
  //  
  override func shouldPerformSegue(withIdentifier identifier: String,
                                   sender: Any?) -> Bool {
    if validateFields() {
      if specimen != nil {
        updateSpecimen()
      } else {
        addNewSpecimen()
      }
      
      return true
    } else {
      return false
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let specimen = specimen {
      title = "Edit \(specimen.name)"
      
      fillTextFields()
    } else {
      title = "Add New Specimen"
    }
  }
}

//
// MARK: - Text Field Delegate
//
extension AddNewEntryViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    performSegue(withIdentifier: "Categories", sender: self)
  }
}

