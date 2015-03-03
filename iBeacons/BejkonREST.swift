//
//  BejkonREST.swift
//  iBeacons
//
//  Created by Norbert Kozlowski on 03/03/15.
//  Copyright (c) 2015 Wojciech Kwiatek. All rights reserved.
//

import Foundation

class BejkonREST {
    let host: String
    
    init(host: String) {
        self.host = host
    }
    
    func findBeacon(uuid: String, major: UInt16, minor: UInt16) {

        var url = "\(host)/beacon?uuid=\(uuid)&major=\(major)&minor=\(minor)"
        
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
        
            if let datastring = NSString(data: data, encoding: NSUTF8StringEncoding) {
                println("received: \(datastring)")
            }

            }.resume()
        
    }
}