import UIKit
import CoreLocation

class InputViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?
    
    @IBAction func save() {
        guard let titleString = titleTextField.text, titleString.characters.count > 0 else { return }
        let date: Date?
        if let dateText = dateTextField.text, dateText.characters.count > 0 {
            date = dateFormatter.date(from: dateText)
        } else {
            date = nil
        }
        let descriptionString = descriptionTextField.text
        if let locationName = locationTextField.text, locationName.characters.count > 0, let address = addressTextField.text, address.characters.count > 0 {
            geocoder.geocodeAddressString(address) { [unowned self] (placeMarks, error) in
                
                let placeMark = placeMarks?.first
                
                let item = ToDoItem(title: titleString, itemDescription: descriptionString, timestamp: date?.timeIntervalSince1970, location: Location(name: locationName, coordinate: placeMark?.location?.coordinate))
                
                DispatchQueue.main.async {
                    self.itemManager?.add(item)
                    self.dismiss(animated: true)
                }
            }
        } else {
            let item = ToDoItem(title: titleString, itemDescription: descriptionString, timestamp: date?.timeIntervalSince1970, location: nil)
            self.itemManager?.add(item)
            dismiss(animated: true)
        }
        
    }
}


fileprivate let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "MM/dd/yyyy"
    return df
}()
