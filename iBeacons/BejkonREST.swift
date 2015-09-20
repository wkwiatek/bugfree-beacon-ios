import Foundation
import Alamofire

struct Response {
    var success = false
    var response: AnyObject? = nil
    var error: NSError? = nil
}

class BejkonREST {
    let host: String
    
    init(host: String) {
        self.host = host
    }
    
    func findBeacon(uuid: String, major: Int, minor: Int, completion: (response: Response) -> ()) {
        var responseFromServer = Response()
        
        Alamofire
            .request(.GET, "\(host)/beacons", parameters: ["uuid": uuid, "major": major.description, "minor": minor.description])
            .responseJSON { request, response, data in
                
                responseFromServer.success = true
                responseFromServer.error = data.error as? NSError
                responseFromServer.response = data.value
                
                completion(response: responseFromServer)
        }
    }
}