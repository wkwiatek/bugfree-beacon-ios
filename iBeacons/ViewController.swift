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
    
    let beaconManager : ESTBeaconManager = ESTBeaconManager();
    
    let colors = [
        12917: UIColor(red: 72/255, green: 209/255, blue: 204/255, alpha: 1)
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        beaconManager.delegate = self;
        
        let region : ESTBeaconRegion = ESTBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"), identifier: "Estimote");
        
        beaconManager.startMonitoringForRegion(region);
        beaconManager.requestStateForRegion(region);
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
        var notification : UILocalNotification = UILocalNotification();
        notification.alertBody = "The shoes you'd tried on are now 20% off for you with this coupon";
        notification.soundName = UILocalNotificationDefaultSoundName;
        UIApplication.sharedApplication().presentLocalNotificationNow(notification);
    }
    
    func beaconManager(manager: ESTBeaconManager!, didRangeBeacons beacons: [AnyObject], inRegion region: ESTBeaconRegion!) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as ESTBeacon;
            self.view.backgroundColor = self.colors[closestBeacon.minor.integerValue];
        }
    }

    
}

