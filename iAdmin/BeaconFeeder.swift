import Foundation

class BeaconFeeder {
    
    // Returns some beacons from ranging
    static func feedFromRanging(handler: (beacons: [Beacon]) -> ()) {
        var beacons = [Beacon]()
        
        let beacon1 = Beacon(minor: 1,major: 2,uuid: "uuid1")
        let beacon2 = Beacon(minor: 34,major: 522,uuid: "uuid2")
        
        beacons.append(beacon1)
        beacons.append(beacon2)
        
        handler(beacons: beacons)
    }
}