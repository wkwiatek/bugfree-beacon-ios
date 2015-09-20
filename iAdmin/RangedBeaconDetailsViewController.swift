import UIKit

class RangedBeaconDetailsViewController: UIViewController, UITextFieldDelegate, ESTBeaconConnectionDelegate {

    var beacon: RangedBeacon?
    var beaconConnection: ESTBeaconConnection?
    var beaconId: String?
    var beaconImageUrl: String?
    var beaconDetailsUrl: String?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    @IBOutlet weak var templateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var titleColorTextField: UITextField!
    @IBOutlet weak var subtitleColorTextField: UITextField!
    @IBOutlet weak var contentColorTextField: UITextField!
    @IBOutlet weak var backgroundColorTextField: UITextField!
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBAction func saveBtn(sender: AnyObject) {
        // Update server & beacon data
        
        if beaconId == nil {
            print("Creating new beacon ...")
            saveBtn.enabled = false
            
            self.beaconConnection!.writePower(ESTBeaconPower.Level8, completion: { (power, error) -> Void in
                print("\(self.rangeSlider.value)")
                print("Changed to power \(power)")
            })
            
            BejkonREST.createBeacon(
                beacon!.uuid,
                major: beacon!.major,
                minor: beacon!.minor,
                customer: "",
                title: titleTextField.text!,
                subtitle: subtitleTextField.text!,
                content: contentTextField.text!,
                imageUrl: "http://example.com",
                detailsUrl: "http://example.com",
                templateType: Utils.getTemplateTypeName(templateSegmentedControl),
                titleColor: titleColorTextField.text!,
                subtitleColor: subtitleColorTextField.text!,
                contentColor: contentColorTextField.text!,
                backgroundColor: backgroundColorTextField.text!) { (response) -> () in
                    self.presentViewController(Utils.getAlertController(), animated: true, completion: nil)
                    self.saveBtn.enabled = true
            }
        } else {
            print("Updating exisitng beacon...")
 
            self.beaconConnection!.writePower(ESTBeaconPower.Level8, completion: { (power, error) -> Void in
                print("\(self.rangeSlider.value)")
                print("Changed to power \(power)")
            })
       
            saveBtn.enabled = false

            BejkonREST.updateBeacon(
                beaconId!,
                uuid: beacon!.uuid,
                major: beacon!.major,
                minor: beacon!.minor,
                customer: "",
                title: titleTextField.text!,
                subtitle: subtitleTextField.text!,
                content: contentTextField.text!,
                imageUrl: beaconImageUrl!,
                detailsUrl: beaconDetailsUrl!,
                templateType: Utils.getTemplateTypeName(templateSegmentedControl),
                titleColor: titleColorTextField.text!,
                subtitleColor: subtitleColorTextField.text!,
                contentColor: contentColorTextField.text!,
                backgroundColor: backgroundColorTextField.text!) { (response) -> () in
                    self.presentViewController(Utils.getAlertController(), animated: true, completion: nil)
                    self.saveBtn.enabled = true
            }
        }
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
        
        self.beaconConnection = ESTBeaconConnection(proximityUUID: NSUUID(UUIDString: beacon!.uuid), major: CLBeaconMajorValue(beacon!.major), minor: CLBeaconMajorValue(beacon!.minor), delegate: self)
        self.beaconConnection!.startConnection()

    }
    
    func beaconConnection(connection: ESTBeaconConnection!, didFailWithError error: NSError!) {
        print("connection to beacon failed with error: \(error)")
    }
    
    func beaconConnectionDidSucceed(connection: ESTBeaconConnection!) {
        print("connected to beacon")
    }
    
    func feedMyBeaconData(id: String, title: String, subtitle: String, content: String, template: String, imageURL: String, detailsURL: String, titleColor: String, subtitleColor: String, contentColor: String, backgroundColor: String) {
        
        beaconId = id
        beaconImageUrl = imageURL
        beaconDetailsUrl = detailsURL
        
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
