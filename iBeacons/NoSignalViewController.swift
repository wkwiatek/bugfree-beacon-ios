import UIKit

class NoSignalViewController: UIViewController {
    
    let beaconManager = BeaconManager.sharedInstance
    var newBeacon: BeaconData?
    
    @IBOutlet weak var noSignalView: UIView! {
        didSet { beaconManager.noSignalView = self }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Wyszukiwanie"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        beaconManager.removeBeaconsInRangeFromMemory()
        beaconManager.startMonitoring()
    }
    
    func presentDetails(beaconData: BeaconData) {
        newBeacon = beaconData
        performSegueWithIdentifier("ShowDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetails" {
            if let destinationVC = segue.destinationViewController as? DetailsViewController {
                destinationVC.beaconData = newBeacon
            }
        }
    }
}
