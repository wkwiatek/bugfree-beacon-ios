import Foundation
import CoreLocation
import SwiftyJSON

extension CLBeacon: Equatable {}

public func ==(lhs: CLBeacon, rhs: CLBeacon) -> Bool {
    return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.proximityUUID == rhs.proximityUUID
}

struct BeaconData {
    let beacon: CLBeacon
    var name: String?
    var carMake: String?
    var carModel: String?
    var milage: String?
    var imageUrl: NSURL?
    var detailsUrl: NSURL?
    
    init(beacon: CLBeacon) {
        self.beacon = beacon
    }
}

class BeaconManager: NSObject, CLLocationManagerDelegate {
    
    let uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    let locationManager: CLLocationManager = CLLocationManager();
    let server: BejkonREST = BejkonREST(host: "http://bejkon.herokuapp.com");

    var beaconsInRange = [CLBeacon]();
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
        let region : CLBeaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: uuid), identifier: "Estimote");

        locationManager.delegate = self;
        locationManager.requestAlwaysAuthorization();

        locationManager.startMonitoringForRegion(region);
        locationManager.startRangingBeaconsInRegion(region);
    }
    
    func stopMonitoring() {
        let region : CLBeaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: uuid), identifier: "Estimote");

        locationManager.stopMonitoringForRegion(region)
        locationManager.stopRangingBeaconsInRegion(region)
    }
    
    func collectData(beacon: AnyObject) {
        var beacon = beacon as CLBeacon;
        var bData = BeaconData(beacon: beacon)

        server.findBeacon(uuid, major: beacon.major.integerValue, minor: beacon.minor.integerValue) { response in
            let json = JSON(response.response!)
            
            bData.name = json[0]["data"]["name"].string
            bData.carMake = json[0]["data"]["carMake"].string
            bData.carModel = json[0]["data"]["carModel"].string
            bData.milage = json[0]["data"]["milage"].string
            bData.imageUrl = NSURL(string: json[0]["data"]["imageUrl"].string!)
            bData.detailsUrl = NSURL(string: json[0]["data"]["detailsUrl"].string!)
            
            self.noSignalView?.presentDetails(bData)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLBeaconRegion!) {
        println("ESTBeaconManagerDelegate staring monitoring for region: \(region.identifier)");
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLBeaconRegion!) {
        println("Beacon entered region");
    }
    
    func removeBeaconsInRangeFromMemory() {
        beaconsInRange.removeAll();
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLBeaconRegion!) {
        println("Beacon left region");
        removeBeaconsInRangeFromMemory()
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject], inRegion region: CLBeaconRegion!) {
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }

        println("Ranged beacons(\(beacons.count)): \(beacons)");

        if (knownBeacons.count > 0) {
            let beacon = knownBeacons[0] as CLBeacon;
            
            if(!contains(beaconsInRange, beacon)) {
                beaconsInRange.append(beacon);
                collectData(beacon)
            }
        } else {
            removeBeaconsInRangeFromMemory()
        }
    }
}