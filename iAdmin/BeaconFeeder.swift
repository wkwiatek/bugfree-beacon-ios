import Foundation

class BeaconFeeder {
    
    static let beaconManager = BeaconManager()
    
    // Returns some beacons from ranging
    static func feedFromRanging(handler: (beacons: [RangedBeacon]) -> ()) {
        handler(beacons: beaconManager.getBeaconsInRange())
    }
    
    // Return customer beacons
    static func feedMyBeacons(handler: (beacons: [MyBeacon]) -> ()) {
        BeaconProvider.getAll("B9407F30-F5F8-466E-AFF9-25556B57FE6D") { beacons in
            handler(beacons: beacons)
        }
    }
}