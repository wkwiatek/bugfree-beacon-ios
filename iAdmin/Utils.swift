import UIKit

class Utils {
    static func delay(#seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
    
    static func getTemplateTypeName(segmentedControl: UISegmentedControl) -> String {
        switch segmentedControl.selectedSegmentIndex {
        case 0: return "ROUNDED_IMAGE"
        case 1: return "SQUARED_IMAGE"
        case 2: return "SQUARED_IMAGE_ALIGN_LEFT"
            
        default: return "ROUNDED_IMAGE"
        }
    }
}