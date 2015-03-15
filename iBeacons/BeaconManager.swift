import Foundation
import EstimoteSDK
import SwiftyJSON

struct BeaconData {
    let beacon: ESTBeacon
    var push_text: String?
    var image_url: NSURL?
    
    init(beacon: ESTBeacon) {
        self.beacon = beacon
    }
}

class BeaconManager: NSObject, ESTBeaconManagerDelegate, BeaconAware {
    
    let uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    let beaconManager: ESTBeaconManager = ESTBeaconManager();
    let server: BejkonREST = BejkonREST(host: "http://bejkon.herokuapp.com");
    
    var beaconsInRange = [ESTBeacon]();
    var beaconsInRangeSorted = [AnyObject]();
    var view: ViewController?
    
    func startMonitoring() {
        let region : ESTBeaconRegion = ESTBeaconRegion(proximityUUID: NSUUID(UUIDString: uuid), identifier: "Estimote");
        
        beaconManager.delegate = self;
        beaconManager.requestAlwaysAuthorization();
        
        beaconManager.startMonitoringForRegion(region);
        beaconManager.startRangingBeaconsInRegion(region);
    }
    
    func collectData(beacon: AnyObject) -> BeaconData {
        var beacon = beacon as ESTBeacon;
        var bData = BeaconData(beacon: beacon)

        bData.push_text = "Some push text"
        bData.image_url = NSURL(string: "http://i.telegraph.co.uk/multimedia/archive/01292/R81_1292690i.jpg")
        
        return bData
    }
    
    func beaconManager(manager: ESTBeaconManager!, didStartMonitoringForRegion region: ESTBeaconRegion!) {
        println("ESTBeaconManagerDelegate staring monitoring for region: \(region.identifier)");
    }
    
    func beaconManager(manager: ESTBeaconManager!, didEnterRegion region: ESTBeaconRegion!) {
        println("Beacon entered region");
    }
    
    func beaconManager(manager: ESTBeaconManager!, didExitRegion region: ESTBeaconRegion!) {
        println("Beacon left region");
        beaconsInRange.removeAll();
        view!.initializeUI()
    }
    
    func beaconManager(manager: ESTBeaconManager!, didRangeBeacons beacons: [AnyObject], inRegion region: ESTBeaconRegion!) {
        println("Ranged beacons: \(beacons)");

        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        beaconsInRangeSorted = beacons;
        
        if (knownBeacons.count > 0) {
            for object in knownBeacons {
                let beacon = object as ESTBeacon;
                
                if(!contains(beaconsInRange, beacon)) {
                    beaconsInRange.append(beacon);
                    view!.initializeUI()
                }
            }
        }

    }
    
    func anyBeaconInRange() -> Bool {
        return beaconsInRange.count > 0
    }
    
    func closestBeacon() -> BeaconData {
        return collectData(beaconsInRange[0])
    }
    
}