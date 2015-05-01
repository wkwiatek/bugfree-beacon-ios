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
        var myBeacons = [MyBeacon]()
        
        let beacon1 = MyBeacon()
        beacon1.title = "Fryzjer"
        beacon1.subtitle = "Odwiedz fryzjera"
        beacon1.content = "Przykladowy content"
        beacon1.titleColor = "#000000"
        beacon1.subtitleColor = "#111111"
        beacon1.contentColor = "#222222"
        beacon1.backgroundColor = "#FFFFFF"
        
        myBeacons.append(beacon1)
        
        handler(beacons: myBeacons)
    }
}