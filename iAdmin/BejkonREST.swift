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
        .request(.GET, "\(host)/beacons", parameters: ["uuid": uuid])
        .responseJSON { request, response, data in
        
            responseFromServer.success = true
            responseFromServer.error = data.error as? NSError
            responseFromServer.response = data.value
            
            completion(response: responseFromServer)
        }
    }
    
    static func findBeacon(uuid: String, major: Int, minor: Int, completion: (response: Response) -> ()) {
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
    
    static func createBeacon(uuid: String, major: Int, minor: Int, customer: String, title: String, subtitle: String, content: String, imageUrl: String, detailsUrl: String, templateType: String, titleColor: String, subtitleColor: String, contentColor: String, backgroundColor: String, completion: (response: Response) -> ()) {
        
        var responseFromServer = Response()
        
        let params: [String : AnyObject] = [
            "uuid": uuid,
            "major": major,
            "minor": minor,
            "customer": customer,
            "data":[
                "title": title,
                "subtitle": subtitle,
                "content": content,
                "imageUrl": imageUrl,
                "detailsUrl": detailsUrl
            ],
            "template":[
                "type": templateType,
                "titleColor": titleColor,
                "subtitleColor": subtitleColor,
                "contentColor": contentColor,
                "backgroundColor": backgroundColor
            ]
        ]
        
        Alamofire
            .request(.POST, "\(host)/beacons/", parameters: params, encoding: .JSON)
            .responseJSON { request, response, responseBody -> Void in
                
                responseFromServer.success = true
                responseFromServer.error = responseBody.error as? NSError
                responseFromServer.response = responseBody.value
                
                print("REQ: \(request)")
                print("RES: \(responseFromServer.response!)")
                
                completion(response: responseFromServer)
        }
        
    }
    
    static func updateBeacon(id: String, uuid: String, major: Int, minor: Int, customer: String, title: String, subtitle: String, content: String, imageUrl: String, detailsUrl: String, templateType: String, titleColor: String, subtitleColor: String, contentColor: String, backgroundColor: String, completion: (response: Response) -> ()) {
        
        var responseFromServer = Response()
        
        let params: [String : AnyObject] = [
            "id": id,
            "uuid": uuid,
            "major": major,
            "minor": minor,
            "customer": customer,
            "data":[
                "title": title,
                "subtitle": subtitle,
                "content": content,
                "imageUrl": imageUrl,
                "detailsUrl": detailsUrl
            ],
            "template":[
                "type": templateType,
                "titleColor": titleColor,
                "subtitleColor": subtitleColor,
                "contentColor": contentColor,
                "backgroundColor": backgroundColor
            ]
        ]
        
        Alamofire
            .request(.PUT, "\(host)/beacons/\(id)", parameters: params, encoding: .JSON)
            .responseJSON { request, response, responseBody -> Void in
                
                responseFromServer.success = true
                responseFromServer.error = responseBody.error as? NSError
                responseFromServer.response = responseBody.value
                
                print("REQ: \(request)")
                
                completion(response: responseFromServer)
        }
    }
    
}