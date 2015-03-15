import Foundation
import Alamofire
import SwiftyJSON

class BejkonREST {
    let host: String
    
    init(host: String) {
        self.host = host
    }
    
    func findBeacon(uuid: String, major: Int, minor: Int, completion: (response: JSON?) -> ()) {    
        Alamofire
            .request(.GET, "\(host)/beacon", parameters: ["uuid": uuid, "major": major.description, "minor": minor.description])
            .responseJSON { (request, response, responseObject, error) in
                println("Received: \(responseObject)")
                completion(response: JSON(responseObject!))
        }
    }
}