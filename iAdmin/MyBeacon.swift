import Foundation

class MyBeacon: AbstractBeacon {
    
    var id: String?
    var title: String?
    var subtitle: String?
    var content: String?
    
    var imageUrl: String?
    var detailsUrl: String?
    
    var template: String?
    var titleColor: String?
    var subtitleColor: String?
    var contentColor: String?
    var backgroundColor: String?
    
    init(major: Int, minor: Int, uuid: String, id: String, title: String, subtitle: String, content: String, imageUrl: String, detailsUrl: String, template: String, titleColor: String, subtitleColor: String, contentColor: String, backgroundColor: String) {
            
        super.init(minor: minor, major: major, uuid: uuid)
        
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.content = content
        
        self.imageUrl = imageUrl
        self.detailsUrl = detailsUrl
        
        self.template = template
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.contentColor = contentColor
        self.backgroundColor = backgroundColor
    }
}