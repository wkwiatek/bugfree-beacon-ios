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
    
    let uuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
    let beaconManager: ESTBeaconManager = ESTBeaconManager();
    let server: BejkonREST = BejkonREST(host: "http://bejkon.herokuapp.com");
    
    let colors = [
        12917: UIColor(red: 72/255, green: 209/255, blue: 204/255, alpha: 1)
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        beaconManager.delegate = self;
        
        let region : ESTBeaconRegion = ESTBeaconRegion(proximityUUID: NSUUID(UUIDString: uuid), identifier: "Estimote");
        
        beaconManager.startMonitoringForRegion(region);
        beaconManager.requestStateForRegion(region);
        beaconManager.startRangingBeaconsInRegion(region);
        
    }
    
    @IBAction func buttonPressed() {
        server.findBeacon(uuid, major: 36077, minor: 12917)
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

            // GET call test
            var postEndpoint: String = "http://jsonplaceholder.typicode.com/posts/1";
            Alamofire.request(.GET, postEndpoint)
                .responseJSON { (request, response, data, error) in
                    if let anError = error {
                        println("error calling GET on /posts/1");
                        println(error);
                    }
                    else if let data: AnyObject = data {
                        let post = JSON(data);
                        println("The post is: " + post.description)
                        if let title = post["title"].string {
                            println("The title is: " + title)
                        }
                        else {
                            println("error parsing /posts/1")
                        }
                    }
            }


        }
    }

    
}

