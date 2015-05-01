import Foundation
import SwiftyJSON

class BeaconProvider {
    
    static func getAll(uuid: String, completion: (beacons: [MyBeacon]) -> ()) {
        var beacons = [MyBeacon]()

        BejkonREST.findAll(uuid) { response in
            let json = JSON(response.response!)

            for (index: String, singleBeacon: JSON) in json {
                
                var beacon = MyBeacon(
                    major: singleBeacon["major"].int!,
                    minor: singleBeacon["minor"].int!,
                    uuid: singleBeacon["uuid"].string!,
                    title: singleBeacon["data"]["title"].string!,
                    subtitle: singleBeacon["data"]["subtitle"].string!,
                    content: singleBeacon["data"]["content"].string!,
                    template: singleBeacon["template"]["type"].string!,
                    titleColor: singleBeacon["template"]["titleColor"].string!,
                    subtitleColor: singleBeacon["template"]["subtitleColor"].string!,
                    contentColor: singleBeacon["template"]["contentColor"].string!,
                    backgroundColor: singleBeacon["template"]["backgroundColor"].string!)

                beacons.append(beacon)
            }
            
            completion(beacons: beacons)
        }
    }
}