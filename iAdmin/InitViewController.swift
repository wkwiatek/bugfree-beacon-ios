import UIKit

class InitViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BeaconFeeder.beaconManager.startRanging()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let destinationVC = segue.destinationViewController as? BeaconsTableViewController {
            switch segue.identifier! {
            case "all_beacons":
                destinationVC.title = "All beacons in range"
                destinationVC.listType = BeaconsTableViewController.BeaconType.RANGED
                break
            case "my_beacons":
                destinationVC.title = "My beacons"
                destinationVC.listType = BeaconsTableViewController.BeaconType.MY
                break
            default:
                break
            }
            
        }
    }
    
}
