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
    
    func findBeacon(uuid: String, major: Int, minor: Int, completionHandler: (responseObject: AnyObject?, error: NSError?) -> ()) {
    
        Alamofire
            .request(.GET, "\(host)/beacon", parameters: ["uuid": uuid, "major": major.description, "minor": minor.description])
            .responseJSON { (request, response, responseObject, error) in
                completionHandler(responseObject: responseObject, error: error)
                
        }
        
    }
}