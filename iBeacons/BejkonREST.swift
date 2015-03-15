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
            .request(.GET, "\(host)/beacon", parameters: ["uuid": uuid, "major": major.description, "minor": minor.description])
            .responseJSON { (request, response, json, error) in
                
                responseFromServer.success = true
                responseFromServer.error = error
                responseFromServer.response = json
                
                completion(response: responseFromServer)
        }
    }
}