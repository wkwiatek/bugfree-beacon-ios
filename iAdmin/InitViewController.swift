import UIKit

class InitViewController: UIViewController {

    @IBOutlet weak var rangeBeaconsBtn: UIButton!
    @IBOutlet weak var myBeaconsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let destinationVC = segue.destinationViewController as? BeaconsTableViewController {
            switch segue.identifier! {
            case "all_beacons":
                destinationVC.title = "All beacons"
                break
            case "my_beacons":
                destinationVC.title = "My beacons"
                break
            default:
                break
            }
            
        }
    }
    
}
