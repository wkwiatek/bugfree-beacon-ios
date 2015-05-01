 import UIKit

class BeaconTableViewCell: UITableViewCell {
    
    var abstractBeacon: AbstractBeacon? {
        didSet {
           updateUI()
        }
    }

    func updateUI() {
        
        if abstractBeacon is MyBeacon {
            let beacon = abstractBeacon as? MyBeacon
            
            self.textLabel?.text = beacon?.title
            self.detailTextLabel?.text = beacon?.subtitle
        }
        
        if abstractBeacon is RangedBeacon {
            let beacon = abstractBeacon as? RangedBeacon
            
            self.textLabel?.text = beacon?.uuid
            self.detailTextLabel?.text = "Major: \(beacon!.major.description), minor: \(beacon!.minor.description)"
        }

    }
}
