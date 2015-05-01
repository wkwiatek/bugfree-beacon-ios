import Foundation
import Alamofire

struct Response {
    var success = false
    var response: AnyObject? = nil
    var error: NSError? = nil
}

//http://bejkon.herokuapp.com/beacon?uuid=B9407F30-F5F8-466E-AFF9-25556B57FE6D

class BejkonREST {
    static let host = "http://bejkon.herokuapp.com"

    static func findAll(uuid: String, completion: (response: Response) -> ()) {
        var responseFromServer = Response()
        
        Alamofire
        .request(.GET, "\(host)/beacon", parameters: ["uuid": uuid])
        .responseJSON { (request, response, json, error) in
        
            responseFromServer.success = true
            responseFromServer.error = error
            responseFromServer.response = json
            
            completion(response: responseFromServer)
        }
    }
    
    static func findBeacon(uuid: String, major: Int, minor: Int, completion: (response: Response) -> ()) {
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