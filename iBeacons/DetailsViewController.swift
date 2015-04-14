import UIKit

class DetailsViewController: UIViewController {
    
    let beaconManager = BeaconManager.sharedInstance
    var beaconData: BeaconData?
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var detailedView: UIView! {
        didSet {
            beaconManager.detailsView = self
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var moreInfoBtn: UIButton!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ddcv = segue.destinationViewController as? UrlDetailsViewController {
            if let identifier = segue.identifier {
                switch identifier {
                    case "ShowUrlDetails":
                        ddcv.url = beaconData?.detailsUrl
                default: break
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.title = "Szczegóły"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initializeUI()
        beaconManager.stopMonitoring()
    }
    
    func initializeUI() {
        if beaconData != nil {
            let imageData = NSData(contentsOfURL: beaconData!.imageUrl!)
            
            mainImage.image = UIImage(data: imageData!)
            mainImage.contentMode = .ScaleAspectFill
            
            mainImage.layer.cornerRadius = mainImage.frame.size.width / 2
            mainImage.layer.borderWidth = 2.0
            mainImage.layer.borderColor = UIColor.blackColor().CGColor
            mainImage.clipsToBounds = true
            
            titleLabel.textColor = Utils.colorWithHexString(beaconData!.titleColor!)
            subtitleLabel.textColor = Utils.colorWithHexString(beaconData!.subtitleColor!)
            contentLabel.textColor = Utils.colorWithHexString(beaconData!.contentColor!)
            self.view.backgroundColor = Utils.colorWithHexString(beaconData!.backgroundColor!)
            
            // Initialize texts here
        }
    }
    
    func noSignal() {
        performSegueWithIdentifier("showNoSignal", sender: self)
    }
}

