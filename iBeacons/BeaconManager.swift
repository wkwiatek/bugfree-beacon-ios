import Foundation
import CoreLocation
import SwiftyJSON

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
    
    func collectData(beacon: AnyObject) {
        var beacon = beacon as CLBeacon;
        var bData = BeaconData(beacon: beacon)

        server.findBeacon(uuid, major: beacon.major.integerValue, minor: beacon.minor.integerValue) { response in
            println("Asking server")
            let json = JSON(response.response!)
            
            bData.name = json[0]["data"]["name"].string
            bData.carMake = json[0]["data"]["carMake"].string
            bData.carModel = json[0]["data"]["carModel"].string
            bData.milage = json[0]["data"]["milage"].string
            bData.imageUrl = NSURL(string: json[0]["data"]["imageUrl"].string!)
            bData.detailsUrl = NSURL(string: json[0]["data"]["detailsUrl"].string!)
            
            println("Go to details view")
            self.noSignalView?.presentDetails(bData)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLBeaconRegion!) {
        println("ESTBeaconManagerDelegate staring monitoring for region: \(region.identifier)");
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLBeaconRegion!) {
        println("Beacon entered region");
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLBeaconRegion!) {
        println("Beacon left region");
        beaconsInRange.removeAll();
        detailsView?.noSignal()
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject], inRegion region: CLBeaconRegion!) {
        println("Ranged beacons: \(beacons)");

        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        beaconsInRangeSorted = beacons;
        
        if (knownBeacons.count > 0) {
            for object in knownBeacons {
                let beacon = object as CLBeacon;
                
                if(!contains(beaconsInRange, beacon)) {
                    beaconsInRange.append(beacon);
                    collectData(beacon)
                }
            }
        }
    }
}