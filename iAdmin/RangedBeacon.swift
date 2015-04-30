import Foundation

class RangedBeacon: AbstractBeacon {
    
    // Here there will be CLBeacon class
    let minor: Int
    let major: Int
    let uuid: String
    
    init(minor: Int, major: Int, uuid: String) {
        self.minor = minor
        self.major = major
        self.uuid = uuid
    }
}