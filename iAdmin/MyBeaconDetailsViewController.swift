import UIKit

class MyBeaconDetailsViewController: UIViewController {

    var beacon: MyBeacon?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        titleTextField.text = beacon?.title!
        subtitleTextField.text = beacon?.subtitle!
        contentTextField.text = beacon?.content!
    }

}
