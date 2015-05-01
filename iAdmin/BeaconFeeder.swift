import Foundation
import CoreLocation

class BeaconFeeder {
    
    // Returns some beacons from ranging
    static func feedFromRanging(handler: (beacons: [RangedBeacon]) -> ()) {
        var rangedBeacons = [RangedBeacon]()

        let beacon1 = RangedBeacon(minor: 1, major: 2, uuid: "uuid1")
        let beacon2 = RangedBeacon(minor: 34, major: 522, uuid: "uuid2")
        
        rangedBeacons.append(beacon1)
        rangedBeacons.append(beacon2)
        
        handler(beacons: rangedBeacons)
    }
    
    // Return customer beacons
    static func feedMyBeacons(handler: (beacons: [MyBeacon]) -> ()) {
        BeaconProvider.getAll("B9407F30-F5F8-466E-AFF9-25556B57FE6D") { beacons in
            handler(beacons: beacons)
        }
    }
}