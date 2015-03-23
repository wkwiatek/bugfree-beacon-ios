import UIKit

class CarDetailsViewController: UIViewController {
    
    var url: NSURL?
    let beaconManager = BeaconManager.sharedInstance
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Oferta"
        displayWebViewContent()
    }
    
    func displayWebViewContent() {
        if let detailsUrl = url {
            let request = NSURLRequest(URL: detailsUrl)
            webView.loadRequest(request)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        beaconManager.stopMonitoring()
    }
    
    override func viewWillDisappear(animated: Bool) {
        beaconManager.startMonitoring()
    }

}
