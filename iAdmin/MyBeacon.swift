import Foundation

class MyBeacon: AbstractBeacon {
    
    var title: String?
    var subtitle: String?
    var content: String?
    
    var template: String?
    var titleColor: String?
    var subtitleColor: String?
    var contentColor: String?
    var backgroundColor: String?
    
    var imageUrl: NSURL?
    var detailsUrl: NSURL?
    
    init(major: Int, minor: Int, uuid: String, title: String, subtitle: String, content: String, template: String,
        titleColor: String, subtitleColor: String, contentColor: String, backgroundColor: String) {
            
            super.init(minor: minor, major: major, uuid: uuid)
            
            self.title = title
            self.subtitle = subtitle
            self.content = content
            self.template = template
            self.titleColor = titleColor
            self.subtitleColor = subtitleColor
            self.contentColor = contentColor
            self.backgroundColor = backgroundColor
    }
}