import EstimoteSDK

class BeaconManager: ESTBeaconManager, ESTBeaconManagerDelegate {
    
    static let uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: uuid),
        identifier: "Estimote")
    
    var beaconsInRange = [CLBeacon]();
    
    override init() {
        super.init()
        beaconManager.delegate = self
        beaconManager.requestWhenInUseAuthorization()
        startRanging()
    }
    
    func startRanging() {
        beaconManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    func stopRanging() {
        beaconManager.stopRangingBeaconsInRegion(beaconRegion)
    }
    
    func beaconManager(manager: AnyObject!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        beaconsInRange = beacons as! Array<CLBeacon>
    }
    
    func getBeaconsInRange() -> [RangedBeacon] {
        var rangedBeacons = [RangedBeacon]()
        
        for beacon in beaconsInRange {
            let minor = beacon.minor as Int
            let major = beacon.major as Int
            rangedBeacons.append(RangedBeacon(minor: minor, major: major, uuid: BeaconManager.uuid))
        }
        
        return rangedBeacons;
    }
    
}
