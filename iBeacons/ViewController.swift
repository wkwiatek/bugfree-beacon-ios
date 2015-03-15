import UIKit

protocol BeaconAware: class {
    func anyBeaconInRange() -> Bool
    func closestBeacon() -> BeaconData
}

class ViewController: UIViewController {
    
    let beaconManager: BeaconManager = BeaconManager()
    
    @IBOutlet weak var mainImage: UIImageView!

    @IBOutlet weak var noSignalView: UIView!
    
    @IBOutlet weak var detailsView: UIView! {
        didSet {
            beaconManager.view = self;
        }
    }
    
    func initializeUI() {
        println("Initializing UI...")
        
        if beaconManager.anyBeaconInRange() {
            println("Got beacon in range")
            let beaconData = beaconManager.closestBeacon()
            let imageData = NSData(contentsOfURL: beaconData.image_url!)
            
            mainImage.image = UIImage(data: imageData!)
            //self.mainImage.contentMode = UIViewContentMode.ScaleAspectFill
            
            mainImage.layer.cornerRadius = mainImage.frame.size.width / 2
            mainImage.layer.borderWidth = 2.0
            mainImage.layer.borderColor = UIColor.whiteColor().CGColor
            mainImage.clipsToBounds = true
            
            signalFound()
        } else {
            println("No beacons in range...")
            noSignal()
        }
    }
    
    private func noSignal() {
        detailsView.layer.hidden = true
        noSignalView.layer.hidden = false
    }
    
    private func signalFound() {
        detailsView.layer.hidden = false
        noSignalView.layer.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        beaconManager.startMonitoring()
        
        initializeUI()
    }
}

