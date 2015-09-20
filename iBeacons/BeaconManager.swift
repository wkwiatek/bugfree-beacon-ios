import Foundation
import CoreLocation
import SwiftyJSON

public func ==(lhs: CLBeacon, rhs: CLBeacon) -> Bool {
    return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.proximityUUID == rhs.proximityUUID
}

struct BeaconData {
    let beacon: CLBeacon
    
    var title: String?
    var subtitle: String?
    var content: String?
    
    var template: String?
    var titleColor: String?
    var subtitleColor: String?
    var contentColor: String?
    var backgroundColor: String?
    
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
    var appActive: Bool = true

    var beaconsInRange = [CLBeacon]();
    var beaconsInRangeSorted = [AnyObject]();
    var closestBeacon = CLBeacon();
    
    var noSignalView: NoSignalViewController?
    var detailsView: DetailsViewController?
    
    class var sharedInstance : BeaconManager {
        struct Static {
            static let instance : BeaconManager = BeaconManager()
        }
        
        return Static.instance
    }
    
    
    func startMonitoring() {
        let region : CLBeaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: uuid)!, identifier: "Estimote");

        locationManager.delegate = self;
        locationManager.requestAlwaysAuthorization();

        locationManager.startMonitoringForRegion(region);
        locationManager.startRangingBeaconsInRegion(region);
    }
    
    func stopMonitoring() {
        let region : CLBeaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: uuid)!, identifier: "Estimote");

        locationManager.stopMonitoringForRegion(region)
        locationManager.stopRangingBeaconsInRegion(region)
    }
    
    func collectData(beacon: AnyObject) {
        let beacon = beacon as! CLBeacon;
        var bData = BeaconData(beacon: beacon)

        server.findBeacon(uuid, major: beacon.major.integerValue, minor: beacon.minor.integerValue) { response in
            let json = JSON(response.response!)
            
            bData.title = json[0]["data"]["title"].string
            bData.subtitle = json[0]["data"]["subtitle"].string
            bData.content = json[0]["data"]["content"].string
            
            bData.template = json[0]["template"]["type"].string
            bData.titleColor = json[0]["template"]["titleColor"].string
            bData.subtitleColor = json[0]["template"]["subtitleColor"].string
            bData.contentColor = json[0]["template"]["contentColor"].string
            bData.backgroundColor = json[0]["template"]["backgroundColor"].string
            
            if let urlString = json[0]["data"]["imageUrl"].string {
                bData.imageUrl = NSURL(string: urlString)
            }
//            bData.imageUrl = NSURL(string: json[0]["data"]["imageUrl"].string!)
            
            if let urlString = json[0]["data"]["detailsUrl"].string {
                bData.detailsUrl = NSURL(string: urlString)
            }
//            bData.detailsUrl = NSURL(string: json[0]["data"]["detailsUrl"].string!)
            
            if (self.appActive) {
                self.noSignalView?.presentDetails(bData)
            } else {
                self.presentPushNotification(bData)
            }
        }
    }
    
    func presentPushNotification(data: BeaconData) {
        let notification : UILocalNotification = UILocalNotification();
        notification.alertBody = data.title! + " " + data.subtitle!;
        notification.soundName = UILocalNotificationDefaultSoundName;
        UIApplication.sharedApplication().presentLocalNotificationNow(notification);
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("ESTBeaconManagerDelegate staring monitoring for region: \(region.identifier)");
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Beacon entered region");
    }
    
    func removeBeaconsInRangeFromMemory() {
        beaconsInRange.removeAll();
    }
    
    func locationManager(manager: CLLocationManager!,idExitRegion region: CLRegion!) {
        print("Beacon left region");
        removeBeaconsInRangeFromMemory()
    }
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
        print("Ranged beacons(\(beacons.count))");
        
        if (knownBeacons.count > 0) {
            
            let beacon = knownBeacons[0]
                
            if (closestBeacon == beacon) {
                print("it's the same beacon in range")
            } else {
                closestBeacon = beacon
                collectData(beacon)
            }
            
        } else {
            removeBeaconsInRangeFromMemory()
        }
    }
}