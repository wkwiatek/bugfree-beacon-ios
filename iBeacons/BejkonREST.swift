//
//  BejkonREST.swift
//  iBeacons
//
//  Created by Norbert Kozlowski on 03/03/15.
//  Copyright (c) 2015 Wojciech Kwiatek. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BejkonREST {
    let host: String
    
    init(host: String) {
        self.host = host
    }
    
    func findBeacon(uuid: String, major: UInt16, minor: UInt16) {
        
        Alamofire
            .request(.GET, "\(host)/beacon", parameters: ["uuid": uuid, "major": major.description, "minor": minor.description])
            .responseJSON { (req, res, response, error) in
                
                if (error != nil) {
                    println(req)
                    println(res)
                } else {
                    var beacon = JSON(response!)
                    
                    println(beacon[0]["image_url"])
                    println(beacon[0]["push_text"])
                }

        }
    }
}