import Foundation
import EstimoteSDK
import SwiftyJSON

class BeaconManager: NSObject, ESTBeaconManagerDelegate {
    
    let uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    let beaconManager: ESTBeaconManager = ESTBeaconManager();
    let server: BejkonREST = BejkonREST(host: "http://bejkon.herokuapp.com");
    
    struct BeaconData {
        let beacon: ESTBeacon
        var push_text: String?
        var image_url: NSURL?
        
        init(beacon: ESTBeacon) {
            self.beacon = beacon
        }
    }
    
    var beaconsInRange = [ESTBeacon]();
    var beaconsInRangeSorted = [AnyObject]();
    
    func startMonitoring() {
        let region : ESTBeaconRegion = ESTBeaconRegion(proximityUUID: NSUUID(UUIDString: uuid), identifier: "Estimote");
        
        beaconManager.delegate = self;
        beaconManager.requestAlwaysAuthorization();
        
        beaconManager.startMonitoringForRegion(region);
        beaconManager.startRangingBeaconsInRegion(region);
    }
    
    func collectData(beacon: AnyObject, completion: (beacon: BeaconData) -> ()) {
        var beacon = beacon as ESTBeacon;
        var bData = BeaconData(beacon: beacon)
        
        server.findBeacon(uuid, major: beacon.major.integerValue, minor: beacon.minor.integerValue) { response in
            var pushText = response![0]["push_text"].string
            var imageUrl = response![0]["image_url"].string
            
            println("Push text: \(pushText)")
            bData.push_text = pushText
            bData.image_url = NSURL(string: imageUrl!)
            completion(beacon: bData)
        }
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
                }
            }
        }
        
//        var viewControllerHandle = ViewController(nibName: "ViewController", bundle: nil);
//        if var activeBeacon = viewControllerHandle.activeBeacons {
//            viewControllerHandle.activeBeacons.text = "\(beacons.count)";
//        }
        
    }

}