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
            .request(.PUT, "\(host)/beacon/\(id)", parameters: params, encoding: .JSON)
            .response { (request, response, responseBody, error) -> Void in
                
                responseFromServer.success = true
                responseFromServer.error = error
                responseFromServer.response = responseBody
                
                completion(response: responseFromServer)
        }
    }
}