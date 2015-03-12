import UIKit

class ViewController: UIViewController {
    
    let beaconManager: BeaconManager = BeaconManager()
    
    @IBOutlet weak var activeBeacons: UILabel!
    
    @IBAction func findBeacons(sender: UIButton) {
        let beacons = beaconManager.beacons
        activeBeacons.text = "\(beacons.count)"
        
        if beacons.count > 0 {
            println("Found \(beacons.count) beacons")
            println("First URL: \(beacons[0].image_url)")
        } else {
            println("Nothing found ;(")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        beaconManager.startMonitoring()
    }
}

