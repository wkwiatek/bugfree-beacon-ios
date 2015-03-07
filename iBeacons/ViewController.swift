//
//  ViewController.swift
//  iBeacons
//
//  Created by Wojciech Kwiatek on 10/02/15.
//  Copyright (c) 2015 Wojciech Kwiatek. All rights reserved.
//

import UIKit
import EstimoteSDK
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, ESTBeaconManagerDelegate {
    
    let uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D";
    let beaconManager: ESTBeaconManager = ESTBeaconManager();
    let server: BejkonREST = BejkonREST(host: "http://bejkon.herokuapp.com");
    
    var notifications = [ESTBeacon]();
    var notification : UILocalNotification = UILocalNotification();
    
    let colors = [
        12917: UIColor(red: 72/255, green: 209/255, blue: 204/255, alpha: 1)
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
        
        beaconManager.delegate = self;
        beaconManager.requestAlwaysAuthorization();
        
        let region : ESTBeaconRegion = ESTBeaconRegion(proximityUUID: NSUUID(UUIDString: uuid), identifier: "Estimote");
        
        beaconManager.startMonitoringForRegion(region);
        beaconManager.startRangingBeaconsInRegion(region);

    }
    
    func beaconManager(manager: ESTBeaconManager!, didStartMonitoringForRegion region: ESTBeaconRegion!) {
        println("ESTBeaconManagerDelegate staring monitoring for region: \(region.identifier)");
    }
    
    func beaconManager(manager: ESTBeaconManager!, didEnterRegion region: ESTBeaconRegion!) {
        println("Beacon entered region");
    }
    
    func beaconManager(manager: ESTBeaconManager!, didExitRegion region: ESTBeaconRegion!) {
        println("Beacon left region");
        notifications.removeAll();
    }
    
    func beaconManager(manager: ESTBeaconManager!, didRangeBeacons beacons: [AnyObject], inRegion region: ESTBeaconRegion!) {
        println("Ranged beacons: \(beacons)");
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        if (knownBeacons.count > 0) {
            for object in knownBeacons {
                let beacon = object as ESTBeacon;
                if(!contains(notifications, beacon)) {
                    println(beacon);
                    server.findBeacon(uuid, major: beacon.major.integerValue, minor: beacon.minor.integerValue) { responseObject, error in
                        var responseJSON = JSON(responseObject!);
                        if let pushText = responseJSON[0]["push_text"].string{
                            //Now you got your value
                            self.notification.alertBody = pushText;
                            self.notification.soundName = UILocalNotificationDefaultSoundName;
                            UIApplication.sharedApplication().presentLocalNotificationNow(self.notification);
                        }
                        
                    }
                    notifications.append(beacon);
                }
            }

            println(notifications);
        }
    }

    
}

