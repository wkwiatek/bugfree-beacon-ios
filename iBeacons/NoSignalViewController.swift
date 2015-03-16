import UIKit

class NoSignalViewController: UIViewController {
    
    let beaconManager = BeaconManager.sharedInstance
    var newBeacon: BeaconData?
    
    @IBOutlet weak var noSignalView: UIView! {
        didSet {
            beaconManager.noSignalView = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beaconManager.startMonitoring()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func presentDetails(beaconData: BeaconData) {
        println("Processing to details view")
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
