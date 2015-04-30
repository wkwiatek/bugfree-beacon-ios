 import UIKit

class BeaconTableViewCell: UITableViewCell {
    
    var abstractBeacon: AbstractBeacon? {
        didSet {
           updateUI()
        }
    }

    func updateUI() {
        
        if abstractBeacon is MyBeacon {
            println("My beacon cell initializer")
            let beacon = abstractBeacon as? MyBeacon
        }
        
        if abstractBeacon is RangedBeacon {
            println("Ranged beacon cell initializer")
            let beacon = abstractBeacon as? RangedBeacon
            
            self.textLabel?.text = beacon?.uuid
            self.detailTextLabel?.text = "Major: \(beacon!.major.description), minor: \(beacon!.minor.description)"
        }
        

    }
}
