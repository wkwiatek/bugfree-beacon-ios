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
                println("Display all found beacons")
                break
            case "my_beacons":
                println("Display my beacons")
                break
            default:
                break
            }
            
        }
    }
    
}
