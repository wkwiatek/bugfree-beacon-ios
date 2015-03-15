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

class BeaconManager: NSObject, ESTBeaconManagerDelegate {
    
    let uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    let beaconManager: ESTBeaconManager = ESTBeaconManager();
    let server: BejkonREST = BejkonREST(host: "http://bejkon.herokuapp.com");
    
    var beaconsInRange = [ESTBeacon]();
    var beaconsInRangeSorted = [AnyObject]();
    
    var noSignalView: NoSignalViewController?
    var detailsView: DetailsViewController?
    
    class var sharedInstance : BeaconManager {
        struct Static {
            static let instance : BeaconManager = BeaconManager()
        }
        
        return Static.instance
    }
    
    
    func startMonitoring() {
        let region : ESTBeaconRegion = ESTBeaconRegion(proximityUUID: NSUUID(UUIDString: uuid), identifier: "Estimote");
        
        beaconManager.delegate = self;
        beaconManager.requestAlwaysAuthorization();
        
        beaconManager.startMonitoringForRegion(region);
        beaconManager.startRangingBeaconsInRegion(region);
    }
    
    func collectData(beacon: AnyObject) {
        var beacon = beacon as ESTBeacon;
        var bData = BeaconData(beacon: beacon)

        server.findBeacon(uuid, major: beacon.major.integerValue, minor: beacon.minor.integerValue) { response in
            println("Asking server")
            let json = JSON(response.response!)
            
            bData.push_text = json[0]["pushText"].string!
            bData.image_url = NSURL(string: json[0]["imageUrl"].string!)
            
            println("Go to details view")
            self.noSignalView?.presentDetails(bData)
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
        detailsView?.noSignal()
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
                    collectData(beacon)
                }
            }
        }
    }
}