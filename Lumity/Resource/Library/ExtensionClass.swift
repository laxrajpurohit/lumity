//
//  ExtensionClass.swift
//  Medics2you
//
//  Created by Techwin iMac-2 on 04/03/20.
//  Copyright © 2020 Techwin iMac-2. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage


//MARK:-  EXTENSION TO STRING..                    ************************************

extension String {
    
    func digitFromString() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    func formatString(format: [Character]) -> String {
        let cleanNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var result = ""
        var index = cleanNumber.startIndex
        for ch in format {
            if index == cleanNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func isValidEmail() -> Bool {
        return NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    
    // Mobile number validation
    func isValidPhoneNumber() -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }

    
    // new verification test
    func validatePhone() -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func dateFromString() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let dateObj = dateFormatter.date(from: self)
        return dateObj!
        //        dateFormatter.dateFormat = "MM-dd-yyyy"
        //        print("Dateobj: \(dateFormatter.string(from: dateObj!))")
    }
    
    func containsSpecialCharacters(string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[^a-z0-9 ]", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) {
                return true
            } else {
                return false
            }
        } catch {
            debugPrint(error.localizedDescription)
            return true
        }
//        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
//        var texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
//
//        var specialresult = texttest2!.evaluateWithObject(text)
//        println("\(specialresult)")
    }
    
    func containsCapitalCharacter(text : String) -> Bool{
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        guard texttest.evaluate(with: text) else { return false }
        return true
    }
    
    func containsNumber(text : String) -> Bool{
        let capitalLetterRegEx  = ".*[0-9]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        guard texttest.evaluate(with: text) else { return false }
        return true
    }
    
  
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    
    func getBase64() -> String? {
        let data = self.data(using: .utf8)
        let encodedStr = data?.base64EncodedString(options: [])
        return encodedStr
    }
    
    func decodeBase64() -> String {
        let decodedData = Data(base64Encoded: self)!
        let decodedString = String(data: decodedData, encoding: .utf8)!
        return decodedString
    }
    
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func removeSpecialCharsFromString() -> String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")//+-=().!_
        return self.filter {okayChars.contains($0) }
    }
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
        
        
    }
    
    //MARK:- Convert Emoji String to Image..
    
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //MARK:- Delete Prefix Character from string..
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    
    //MARK:- Get Attributed String..
    
    func getAttributedString(color:UIColor)->NSAttributedString{
        
        let myAttribute = [NSAttributedString.Key.foregroundColor: color]
        let myAttrString = NSAttributedString(string: self, attributes: myAttribute)
        return myAttrString
    }
    
    
    func editTimeString(timeString: String) -> String {
        var last2 = timeString.suffix(2)
        print(last2)
        if(last2.count==1){
            last2 = last2+"0"
        }
        var startingChar = "0"
        if(timeString.count>2){
            startingChar = String(timeString.prefix(timeString.count-2))
        }
        print(startingChar)
        return  String(format: "%@:%@", startingChar as CVarArg,last2 as CVarArg)
    }
    
    func timeConversion12(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        
        let date = df.date(from: dateAsString)
        df.dateFormat = "hh:mm a"
        
        let time12 = df.string(from: date!)
        print(time12)
        return time12
    }
    
}



//MARK:-  EXTENSION TO FLOAT..************************************

extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension UIImageView {
    
    func setImage(url: String, placeholderImageView: UIImage?) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: URL(string: url), placeholderImage: placeholderImageView)
    }
}


//MARK:-  EXTENSION TO UIIMAGE VIEW..************************************

extension UIImageView {
    
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
    
    func cornerImage(cornerRadius : CGFloat)  {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    
    func addDiamondMask(cornerRadius: CGFloat = 0) {
        let path = UIBezierPath()
        let points = [ // MARK:- DIAMOND MASK FOR IMAGE.
            CGPoint(x: bounds.midX, y: bounds.minY),
            CGPoint(x: bounds.maxX, y: bounds.midY),
            CGPoint(x: bounds.midX, y: bounds.maxY),
            CGPoint(x: bounds.minX, y: bounds.midY)
        ]
        
        let newpoints = [  // MARK:- DIAMOND MASK WITH CUSTOM CORERS.
            CGPoint(x: bounds.midX - 5, y: bounds.minY),
            CGPoint(x: bounds.midX + 5, y: bounds.minY),
            CGPoint(x: bounds.maxX, y: bounds.midY - 5),
            CGPoint(x: bounds.maxX, y: bounds.midY + 5),
            CGPoint(x: bounds.midX + 5, y: bounds.maxY),
            CGPoint(x: bounds.midX - 5 , y: bounds.maxY),
            CGPoint(x: bounds.minX, y: bounds.midY + 5),
            CGPoint(x: bounds.minX, y: bounds.midY - 5)
        ]
        
        path.move(to: point(from: newpoints[0], to: newpoints[1], distance: cornerRadius, fromStart: true))
        for j in 0 ..< 8 {
            path.addLine(to: point(from: newpoints[j], to: newpoints[(j + 1) % 8], distance: cornerRadius, fromStart: false))
            //path.addQuadCurve(to: point(from: newpoints[(j + 1) % 4], to: newpoints[(j + 2) % 4], distance: cornerRadius, fromStart: true), controlPoint: newpoints[(j + 1) % 4])
        }
        //        path.move(to: point(from: points[0], to: points[1], distance: cornerRadius, fromStart: true))
        //        for i in 0 ..< 4 {
        //
        //            path.addLine(to: point(from: points[i], to: points[(i + 1) % 4], distance: cornerRadius, fromStart: false))
        //            //path.addQuadCurve(to: point(from: points[(i + 1) % 4], to: points[(i + 2) % 4], distance: cornerRadius, fromStart: true), controlPoint: points[(i + 1) % 4])
        //
        //        }
        path.close()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        layer.mask = shapeLayer
        
    }
    //    extension UIImageView {
    //        func addDiamondMask(cornerRadius: CGFloat = 0) {
    //            let path = UIBezierPath()
    //
    //            let points = [
    //                CGPoint(x: bounds.midX, y: bounds.minY),
    //                CGPoint(x: bounds.maxX, y: bounds.midY),
    //                CGPoint(x: bounds.midX, y: bounds.maxY),
    //                CGPoint(x: bounds.minX, y: bounds.midY)
    //            ]
    //
    //            path.move(to: point(from: points[0], to: points[1], distance: cornerRadius, fromStart: true))
    //            for i in 0 ..< 4 {
    //                path.addLine(to: point(from: points[i], to: points[(i + 1) % 4], distance: cornerRadius, fromStart: false))
    //                path.addQuadCurve(to: point(from: points[(i + 1) % 4], to: points[(i + 2) % 4], distance: cornerRadius, fromStart: true), controlPoint: points[(i + 1) % 4])
    //            }
    //            path.close()
    //
    //            let shapeLayer = CAShapeLayer()
    //            shapeLayer.path = path.cgPath
    //            shapeLayer.fillColor = UIColor.white.cgColor
    //            shapeLayer.strokeColor = UIColor.clear.cgColor
    //
    //            layer.mask = shapeLayer
    //
    //        }
    private func point(from point1: CGPoint, to point2: CGPoint, distance: CGFloat, fromStart: Bool) -> CGPoint {
        let start: CGPoint
        let end: CGPoint
        
        if fromStart {
            start = point1
            end = point2
        } else {
            start = point2
            end = point1
        }
        let angle = atan2(end.y - start.y, end.x - start.x)
        return CGPoint(x: start.x + distance * cos(angle), y: start.y + distance * sin(angle))
    }
    
    func image(with image: UIImage, scaledTo newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = newImage
        return newImage ?? UIImage()
    }


}

extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


//MARK:-  EXTENSION TO UIBUTTON..************************************

extension UIButton {
    
    func cornerButton(cornerRadius : CGFloat)  {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    func layoutDesign(cornerRadius : CGFloat , bgColor : UIColor , borderColor : UIColor , borderWidth : CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.backgroundColor = bgColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func setCurrentImageFromUrl ( url : String) {
        URLSession.shared.dataTask( with: NSURL(string:url)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let data = data {
                    self.setImage(UIImage(data: data), for: .normal)
                }
            }
        }).resume()
    }
    
}
extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

//MARK:-  EXTENSION TO UIVIEW ..************************************

extension UIView{
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    func cornerView(cornerRadius : CGFloat)  {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    func shadow(view:UIView){
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 1.0
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 2
    }
    func layoutDesignView(cornerRadius : CGFloat , bgColor : UIColor , borderColor : UIColor , borderWidth : CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.backgroundColor = bgColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    func shadowView(Color: UIColor, opacity: Float, radius: CGFloat){
        self.layer.masksToBounds = false
        self.layer.shadowColor = Color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = radius
    }
    
    func plusGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 3.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func putShadow(){
        self.layer.cornerRadius = 5.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
    }
    
//        var safeAreaHeight: CGFloat {
//            if #available(iOS 11, *) {
//                return safeAreaLayoutGuide.layoutFrame.size.height
//            }
//            return bounds.height
//        }
    
}


//MARK:-  EXTENSION TO CALAYER..************************************

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        addSublayer(border)
    }
}

//MARK:-  EXTENSION TO UITABLEVIEW CELL..************************************

extension UITableViewCell {
    
    func setDisclosure(toColour: UIColor) -> () {
        for view in self.subviews {
            if let disclosure = view as? UIButton {
                if let image = disclosure.backgroundImage(for: .normal) {
                    let colouredImage = image.withRenderingMode(.alwaysTemplate);
                    disclosure.setImage(colouredImage, for: .normal)
                    disclosure.tintColor = toColour
                }
            }
        }
    }
}

//MARK:-  EXTENSION TO UIIMAGE..************************************


extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    func resized() -> UIImage? {
        print("width",size.width)
        print("height",size.height)
        if size.width > 1024{
            let ratio = size.width/size.height
            let widthRatio = 1024/size.width
            let width = size.width * widthRatio
            let height = width/ratio
            let canvasSize = CGSize(width: width, height: height)
            UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
            defer { UIGraphicsEndImageContext() }
            draw(in: CGRect(origin: .zero, size: canvasSize))
            return UIGraphicsGetImageFromCurrentImageContext()
        }else{
            return self
        }
    }
    
    
}
//MARK:-  EXTENSION TO DATA..                    ************************************

extension Data {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

//MARK:-  EXTENSION TO NSMUTABLE DATA..                    ************************************

extension NSMutableData {
    
    func append (_ string : String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

//MARK:-  EXTENSION TO DOUBLE..                    ************************************

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}




//MARK:-  EXTENSION TO UIVIEW LABEL..                    ************************************

extension UILabel
{
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = false)
    {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        if (bolAfterLabel)
        {
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(attachmentString)
            
            self.attributedText = strLabelText
        }
        else
        {
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage()
    {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}

//MARK:-  EXTENSION TO UIVIEW TEXTFIELD..                    ************************************


extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setLeftImage(imgName: String){
        
        self.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: imgName )
        imageView.image = image
        self.leftView = imageView
    }
    
    func setRightImage(imgName: String){
        
        self.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: -10, y: 0, width: 20, height: 20))
        let image = UIImage(named: imgName )
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.rightView = imageView
    }
    
    //MARK:- Add Bottom Line For TextField..
    
    func setBottomBorder() {
        
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
}

extension Date {
    static func getDates(forLastNDays nDays: Int) -> [String] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())
        
        var arrDates = [String]()
        
        for _ in 1 ... nDays {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        print(arrDates)
        return arrDates
    }
    
    static func getDates2(forNextNDays nDays: Int) -> [String] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())
        
        var arrDates = [String]()
         date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!
        for _ in 1 ... nDays {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: 1, to: date)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        print(arrDates)
        return arrDates
    }
    
    static func getMonths(forNextNMonths nMonths: Int) -> [String] {
        let cal = NSCalendar.current
        // start with today
        var date = cal.startOfDay(for: Date())
        
        var arrDates = [String]()
        date = cal.date(byAdding: Calendar.Component.month, value: -3, to: date)!
        for _ in 1 ... nMonths {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.month, value: 1, to: date)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        print(arrDates)
        return arrDates
    }
    
    
}


//MARK:-  EXTENSION TO UIVIEW CONTROLLER..                    ************************************

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    public func animateTextField(textField: UITextField, up: Bool, withOffset offset:CGFloat) {
        
        let movementDistance : Int = -Int(offset)
        let movementDuration : Double = 0.4
        let movement : Int = (up ? movementDistance : -movementDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement))
        UIView.commitAnimations()
    }
    
    public func animateTextView(textView: UITextView, up: Bool, withOffset offset:CGFloat) {
        
        let movementDistance : Int = -Int(offset)
        let movementDuration : Double = 0.4
        let movement : Int = (up ? movementDistance : -movementDistance)
        
        UIView.beginAnimations("animateTextView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(movement) )
        UIView.commitAnimations()
    }
    
    public func kAlertView(title:String , message:String?)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
 
    public func shakeView(viewToShake : UIView) {
        viewToShake.layer.borderWidth = 1.0
        viewToShake.layer.borderColor = UIColor.red.cgColor
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x : viewToShake.center.x - 10, y : viewToShake.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x : viewToShake.center.x + 10, y : viewToShake.center.y))
        viewToShake.layer.add(animation, forKey: "position")
    }
    
    
    // URLRequest to NSMutableURLRequest
    func urlToMutableUrlRequest(urlReq : URLRequest) -> NSMutableURLRequest? {
        guard let mutableRequest = (urlReq as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            // Handle the error
            return nil
        }
        return mutableRequest
    }
    
    /* back to previous controller */
    func popView()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    /* Push to next controller */
    
    func pushview(objtype: UIViewController)
    {
        navigationController?.pushViewController(objtype, animated: true)
    }
    
    /* Pop to specific controller */
    //        func popTo(vc : UIViewController) {
    //            for controller in navigationController!.viewControllers as Array {
    //                if controller.isKind(of: vc.self) {
    //                    self.navigationController!.popToViewController(controller, animated: true)
    //                    break
    //                }
    //            }
    //        }
    // check simulator
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
            isSim = true
            #endif
            return isSim
        }()
    }
    
    func kSelfDismissingAlertView(title:String , message:String)  {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK:- Alert Show
    func windowAlertView(_ message: String) {
        
        let alertView = UIAlertController(title: "Medics2you", message: message, preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
        
    }
    
    
   
  
    //MARK:- Error Message..
    
    func showErrorAlert(message: String) {
        //        showAlert(title: "Error", message: message)
        self.kAlertView(title: "Error", message: message)
    }
    
  
    
    
    //MARK:- Top Most View Controller in Heirarichy..
    
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
    
}//..

// MARK:- EXTENSION TO RANGE.
extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}



// MARK:- EXTENSION TO APPDELEGATE CLASS.

@available(iOS 13.0, *)
extension AppDelegate { //UIApplication
    
    func topMostViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController?.topMostViewController()
    }
    
}

//MARK:- UIAlert controller Extension..

public extension UIAlertController {
    
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
    
}

//MARK:- Extension to collection type.

extension Collection where Iterator.Element == [String:Any] {
    
    func toJSONString(options: JSONSerialization.WritingOptions = []) -> String {
        if let arr = self as? [[String:Any]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
    
    func backToViewController(viewController: Swift.AnyClass) {
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}
extension String {
    
    public func isImage() -> Bool {
        // Add here your image formats.
        let imageFormats = ["jpg", "jpeg", "png", "gif"]
        
        if let ext = self.getExtension() {
            return imageFormats.contains(ext)
        }
        
        return false
    }
    
    public func getExtension() -> String? {
        let ext = (self as NSString).pathExtension
        
        if ext.isEmpty {
            return nil
        }
        
        return ext
    }
    
    public func isURL() -> Bool {
        return URL(string: self) != nil
    }
    
    
    func toDateFromUTCString(format: String) -> String {
        let dateFormatter = DateFormatter()
        //        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: self)!
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: date)
    }
    
    func toDateString(format: String) -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: self)!
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func attributedString(attributesText: [String], font: UIFont?) ->  NSAttributedString {
        let attributedString = NSMutableAttributedString(string:self)
        attributesText.forEach{
            if let range = self.range(of: $0)?.nsRange(in: self) {
                attributedString.addAttributes([NSAttributedString.Key.font: font ??  UIFont.systemFont(ofSize: 15)], range: range)

            }
        }
        return attributedString
    }
    
    func attributedStringWithColor(attributesText: [String], font: UIFont?) ->  NSAttributedString {
        let attributedString = NSMutableAttributedString(string:self)
        attributesText.forEach{
            if let range = self.range(of: $0)?.nsRange(in: self) {
                attributedString.addAttributes([NSAttributedString.Key.font: font ??  UIFont.systemFont(ofSize: 15)], range: range)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.08594211191, green: 0.1554124057, blue: 0.3465729356, alpha: 1), range: range)
            }
        }
        return attributedString
    }
}

extension Date {
    
    static func getCurrentDate() -> String {
        return Date().toString(withFormat: "dd-MM-yyyy")
    }
    
    func startOfMonthString() -> String {
        let date = Date().startOfMonth()
        return date.toString(withFormat: "dd-MM-yyyy")
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func endOfMonthString() -> String {
        let date = Date().endOfMonth()
        return date.toString(withFormat: "dd-MM-yyyy")
    }
    
    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = format
        return formatter.string(from: yourDate!)
    }
    
}

extension UIColor {
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
}

extension Int {
    func formatedTime() -> String {
        let hr = Int(self / 3600)
        let min = Int((self % 3600) / 60)
        let sec = Int(self % 60)
        return String(format: "%02d:%02d:%02d", hr, min, sec)
    }
}
extension String {
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    var htmlAttributed: (NSAttributedString?, NSDictionary?) {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return (nil, nil)
            }
            
            var dict:NSDictionary?
            dict = NSMutableDictionary()
            
            return try (NSAttributedString(data: data,
                                           options: [.documentType: NSAttributedString.DocumentType.html,
                                                     .characterEncoding: String.Encoding.utf8.rawValue],
                                           documentAttributes: &dict), dict)
        } catch {
            print("error: ", error)
            return (nil, nil)
        }
    }
    
    func htmlAttributed(using font: UIFont, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(font.pointSize)pt !important;" +
                "color: #\(color.hexString!) !important;" +
                "font-family: \(font.familyName), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    func htmlAttributed(family: String?, size: CGFloat, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "color: #\(color.hexString!) !important;" +
                "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
}

extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,
                                                                .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}

extension UITextField {
    
    func setEmptyDetail() {
        self.text = "---"
    }
}

extension UILabel {
    
    func setEmptyDetail() {
        self.text = "---"
    }
    
    func setHTMLFromString(htmlText: String, fontSize: CGFloat){
        let modifiedFont = String(format:"<span style=\"font-family: 'MarkPro'; font-size: \(fontSize)\">%@</span>", htmlText) //\(self.font!.pointSize - 2)
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        self.attributedText = attrStr
        self.textColor = #colorLiteral(red: 0.08594211191, green: 0.1554124057, blue: 0.3465729356, alpha: 1)
    }
    
    func addBoldFontAttributeInLabel(str: String, attributedStr: [String] ) {
        let attributedString = NSMutableAttributedString(string:str)
        let font = UIFont(name: "MarkPro-Bold", size: 12.0)
        attributedStr.forEach{
            let range = str.range(of: $0)?.nsRange(in: str)
            attributedString.addAttributes([NSAttributedString.Key.font: font ??  UIFont.systemFont(ofSize: 15)], range: range!)
        }
        self.attributedText = attributedString
    }
    
    func addBoldFontAttributeInLabelWithSize(str: String, size: CGFloat, attributedStr: [String] ) {
        let attributedString = NSMutableAttributedString(string:str)
        let font = UIFont(name: "MarkPro-Bold", size: size)
        attributedStr.forEach{
            let range = str.range(of: $0)?.nsRange(in: str)
            attributedString.addAttributes([NSAttributedString.Key.font: font ??  UIFont.systemFont(ofSize: 15)], range: range!)
        }
        self.attributedText = attributedString
    }
    
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attrString = label.attributedText else {
            return false
        }

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attrString)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height

            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: 50)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = Utility.getUIcolorfromHex(hex: "8E8D8A").withAlphaComponent(0.5)
        placeholderLabel.tag = 100
        placeholderLabel.numberOfLines = 0
        placeholderLabel.lineBreakMode = .byWordWrapping
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}
extension Array where Element: Comparable {
    func isAscending() -> Bool {
        return zip(self, self.dropFirst()).allSatisfy(<=)
    }

    func isDescending() -> Bool {
        return zip(self, self.dropFirst()).allSatisfy(>=)
    }
}
extension UITableView {

    func scrollToBottom(with Animation: Bool){
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: Animation)
            }
        }
    }

    func scrollToTop(WithAnimation: Bool) {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: WithAnimation)
           }
        }
    }
}
class NibView: UIView {
    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup view from .xib file
        xibSetup()
    }
}
private extension NibView {
    
    func xibSetup() {
        backgroundColor = UIColor.clear
        view = loadNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Adding custom subview on top of our view
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
    }
}
extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
extension UIView {

    func applyGradient(colours: [UIColor],cornurRadius:CGFloat) {
        self.applyGradient(colours: colours, cornurRadius:cornurRadius, locations: nil)
    }


    func applyGradient(colours: [UIColor], cornurRadius:CGFloat,locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.cornerRadius = cornurRadius
        self.layer.masksToBounds = true
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func removeGradient(selectedGradientView:UIView){
        selectedGradientView.layer.sublayers = selectedGradientView.layer.sublayers?.filter { theLayer in
                !theLayer.isKind(of: CAGradientLayer.classForCoder())
          }
    }
}

extension UIView{

    func gradientButton(_ buttonText:String, startColor:UIColor, endColor:UIColor,borderWidth:CGFloat,cornerRadius:CGFloat) {

        let button:UIButton = UIButton(frame: self.bounds)
        button.setTitle(buttonText, for: .normal)
        button.titleLabel?.font =  UIFont(name: "Calibri-Bold", size: 16)
        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
        self.mask = button

        button.layer.cornerRadius =  cornerRadius
        button.layer.borderWidth = borderWidth
    }
}
