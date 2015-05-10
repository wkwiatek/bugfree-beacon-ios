import UIKit

class MyBeaconDetailsViewController: UIViewController, UITextFieldDelegate {

    var beacon: MyBeacon?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var titleColorTextField: UITextField!
    @IBOutlet weak var subtitleColorTextField: UITextField!
    @IBOutlet weak var contentColorTextField: UITextField!
    @IBOutlet weak var backgroundColorTextField: UITextField!
    @IBOutlet weak var templateSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleTextField.delegate = self
        self.subtitleTextField.delegate = self
        self.contentTextField.delegate = self
        self.titleColorTextField.delegate = self
        self.subtitleColorTextField.delegate = self
        self.contentColorTextField.delegate = self
        self.backgroundColorTextField.delegate = self
        
        updateUI()
    }
    
    func updateUI() {
        titleTextField.text = beacon?.title!
        subtitleTextField.text = beacon?.subtitle!
        contentTextField.text = beacon?.content!
        titleColorTextField.text = beacon?.titleColor!
        subtitleColorTextField.text = beacon?.subtitleColor!
        contentColorTextField.text = beacon?.contentColor!
        backgroundColorTextField.text = beacon?.backgroundColor!
        
        println("Template: \(beacon?.template)")

        switch beacon!.template! {
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

    @IBAction func saveBeaconData(sender: AnyObject) {
        println("Updating beacon with new data, template")
        
        BejkonREST.updateBeacon(
            beacon!.id!,
            uuid: beacon!.uuid,
            major: beacon!.major,
            minor: beacon!.minor,
            customer: "",
            title: titleTextField.text,
            subtitle: subtitleTextField.text,
            content: contentTextField.text,
            imageUrl: beacon!.imageUrl!,
            detailsUrl: beacon!.detailsUrl!,
            templateType: Utils.getTemplateTypeName(templateSegmentedControl),
            titleColor: titleColorTextField.text,
            subtitleColor: subtitleTextField.text,
            contentColor: contentColorTextField.text,
            backgroundColor: backgroundColorTextField.text) { (response) -> () in
                self.presentViewController(Utils.getAlertController(), animated: true, completion: nil)
        }

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
