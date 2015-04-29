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
        println("Performing segue to template \(newBeacon?.template)")
        performSegueWithIdentifier(newBeacon?.template, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let destinationVC = segue.destinationViewController as? DetailsViewController {
            destinationVC.beaconData = newBeacon
        
            switch segue.identifier! {
            case "ROUNDED_IMAGE":
                println("Settings things for template ROUNDED_IMAGE")
                break
            case "SQUARED_IMAGE":
                println("Settings things for template SQUARED_IMAGE")
                break
            case "SQUARED_IMAGE_ALIGN_LEFT":
                println("Settings things for template SQUARED_IMAGE_ALIGN_LEFT")
                break
            default:
                break
            }
        }
    }
}
