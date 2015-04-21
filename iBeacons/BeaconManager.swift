import Foundation
import CoreLocation
import SwiftyJSON

extension CLBeacon: Equatable {}

public func ==(lhs: CLBeacon, rhs: CLBeacon) -> Bool {
    if lhs.major == nil || lhs.minor == nil  || lhs.proximityUUID == nil || rhs.major == nil || rhs.minor == nil  || rhs.proximityUUID == nil {
        return false
    }
    
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
        var beacon = beacon as! CLBeacon;
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

            bData.imageUrl = NSURL(string: json[0]["data"]["imageUrl"].string!)
            bData.detailsUrl = NSURL(string: json[0]["data"]["detailsUrl"].string!)
            
            if (self.appActive) {
                self.noSignalView?.presentDetails(bData)
            } else {
                self.presentPushNotification(bData)
            }
        }
    }
    
    func presentPushNotification(data: BeaconData) {
        var notification : UILocalNotification = UILocalNotification();
        notification.alertBody = data.title! + " " + data.subtitle!;
        notification.soundName = UILocalNotificationDefaultSoundName;
        UIApplication.sharedApplication().presentLocalNotificationNow(notification);
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        println("ESTBeaconManagerDelegate staring monitoring for region: \(region.identifier)");
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("Beacon entered region");
    }
    
    func removeBeaconsInRangeFromMemory() {
        beaconsInRange.removeAll();
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("Beacon left region");
        removeBeaconsInRangeFromMemory()
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject], inRegion region: CLBeaconRegion!) {
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }

        println("Ranged beacons(\(beacons.count))");

        if (knownBeacons.count > 0) {
            
            if let beacon = knownBeacons[0] as? CLBeacon {

                if (closestBeacon == beacon) {
                    println("it's the same beacon in range")
                } else {
                    closestBeacon = beacon
                    collectData(beacon)
                }
            }

        } else {
            removeBeaconsInRangeFromMemory()
        }
    }
}