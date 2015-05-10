import UIKit

class RangedBeaconDetailsViewController: UIViewController, UITextFieldDelegate {

    var beacon: RangedBeacon?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var templateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleColorTextField: UITextField!
    @IBOutlet weak var subtitleColorTextField: UITextField!
    @IBOutlet weak var contentColorTextField: UITextField!
    @IBOutlet weak var backgroundColorTextField: UITextField!
    
    @IBAction func saveBtn(sender: AnyObject) {
        // Update server & beacon data
        println("Updating beacon with UUID: \(beacon?.uuid)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleTextField.delegate = self
        self.subtitleTextField.delegate = self
        self.contentTextField.delegate = self
        self.titleColorTextField.delegate = self
        self.subtitleColorTextField.delegate = self
        self.contentColorTextField.delegate = self
        self.backgroundColorTextField.delegate = self
    }
    
    func feedMyBeaconData(title: String, subtitle: String, content: String, template: String, titleColor: String, subtitleColor: String, contentColor: String, backgroundColor: String) {
        
        titleTextField.text = title
        subtitleTextField.text = subtitle
        contentTextField.text = content
        titleColorTextField.text = titleColor
        subtitleColorTextField.text = subtitleColor
        contentColorTextField.text = contentColor
        backgroundColorTextField.text = backgroundColor
        
        switch template {
        case "ROUNDED_IMAGE":
            templateSegmentedControl.selectedSegmentIndex = 0
        case "SQUARED_IMAGE":
            templateSegmentedControl.selectedSegmentIndex = 1
        case "SQUARED_IMAGE_ALIGN_LEFT":
            templateSegmentedControl.selectedSegmentIndex = 2
        default:
            templateSegmentedControl.selected = false
            break
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
