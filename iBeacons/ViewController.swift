import UIKit

class ViewController: UIViewController {
    
    let beaconManager: BeaconManager = BeaconManager()
    
    @IBOutlet weak var activeBeacons: UILabel!
    @IBOutlet var mainImage: UIImageView! = UIImageView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
    
    @IBAction func findBeacons(sender: UIButton) {
        let beacons = beaconManager.beaconsInRangeSorted
//        activeBeacons.text = "\(beacons.count)"
        
        if beacons.count > 0 {
            
            beaconManager.collectData(beacons[0]) {
                beacon in
                println("First URL: \(beacon.image_url)")
                let data = NSData(contentsOfURL: beacon.image_url!)
                self.mainImage.image = UIImage(data: data!)
            }

        } else {
            println("Nothing found ;(")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        beaconManager.startMonitoring()
    }
}

