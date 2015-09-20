import Foundation
import UIKit

class Utils {
    
    class func colorWithHexString (hex:String) -> UIColor {
//        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
//        
//        if (cString.hasPrefix("#")) {
//            cString = cString.substringFromIndex(advancedBy(cString.startIndex, 1))
//        }
//        
//        if (Swift.count(cString) != 6) {
//            return UIColor.grayColor()
//        }
//        
//        var rgbValue:UInt32 = 0
//        NSScanner(string: cString).scanHexInt(&rgbValue)
//        
//        return UIColor(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
        
        let scanner = NSScanner(string:hex)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}