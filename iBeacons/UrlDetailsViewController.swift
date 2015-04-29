import UIKit

class UrlDetailsViewController: UIViewController {
    
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
}
