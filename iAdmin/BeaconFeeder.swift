import Foundation
import CoreLocation

class BeaconFeeder {
    
    // Returns some beacons from ranging
    static func feedFromRanging(handler: (beacons: [RangedBeacon]) -> ()) {
        var rangedBeacons = [RangedBeacon]()
        
        // TODO: Implement me smarter
        
        let beacon1 = RangedBeacon(minor: 1, major: 2, uuid: "uuid1")
        let beacon2 = RangedBeacon(minor: 34, major: 522, uuid: "uuid2")
        
        rangedBeacons.append(beacon1)
        rangedBeacons.append(beacon2)
        
        handler(beacons: rangedBeacons)
    }
    
    // Return customer beacons
    static func feedMyBeacons(handler: (beacons: [MyBeacon]) -> ()) {
        var myBeacons = [MyBeacon]()
        
        // TODO: Implement me
        let beacon1 = MyBeacon()
        beacon1.title = "Fryzjer"
        beacon1.subtitle = "Odwiedz fryzjera"
        
        myBeacons.append(beacon1)
        
        handler(beacons: myBeacons)
    }
}