import Foundation

class Beacon {
    let minor: Int
    let major: Int
    let uuid: String
    
    var title: String?
    var subtitle: String?
    var content: String?
    
    init(minor: Int, major: Int, uuid: String) {
        self.minor = minor
        self.major = major
        self.uuid = uuid
    }
}