import UIKit

class DetailsViewController: UIViewController {
    
    let beaconManager = BeaconManager.sharedInstance
    var beaconData: BeaconData?
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var carMake: UILabel!
    @IBOutlet weak var carModel: UILabel!
    @IBOutlet weak var milage: UILabel!
    
    @IBOutlet weak var detailedView: UIView! {
        didSet {
            beaconManager.detailsView = self
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ddcv = segue.destinationViewController as? CarDetailsViewController {
            if let identifier = segue.identifier {
                switch identifier {
                    case "ShowCarDetails":
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
            
            carMake.text = beaconData!.carMake
            carModel.text = beaconData!.carModel
            milage.text = beaconData!.milage
        }
    }
    
    func noSignal() {
        performSegueWithIdentifier("showNoSignal", sender: self)
    }
}

