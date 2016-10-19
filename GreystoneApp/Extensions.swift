//
//  Extensions.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 6/17/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit
import CryptoSwift
import QuartzCore


class Extensions: NSObject {

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIView {
    
    func roundedCorners(radius : CGFloat) {
        let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners:[.TopRight, .TopLeft], cornerRadii: CGSizeMake(radius, radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.CGPath
        self.layer.mask = maskLayer
    }
    
    func roundedCorners(radius : CGFloat, roundingCorners : UIRectCorner) {
        let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSizeMake(radius, radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.CGPath
        self.layer.mask = maskLayer
    }
}

extension CALayer {
    
    func setBorderColorFromUIcolor(color : UIColor) {
        self.borderColor! = color.CGColor
    }
    
        var borderColorFromUIColor: UIColor {
            get {
                return UIColor(CGColor: self.borderColor!)
            } set {
                self.borderColor = newValue.CGColor
            }
        }
    
    func roundedCorners(radius : CGFloat, roundingCorners : UIRectCorner) {
        let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSizeMake(radius, radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.CGPath
        self.mask = maskLayer
    }
}

extension String {
    func toBase64() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        return data?.base64EncodedStringWithOptions([]) ?? ""
    }
    
    func fromBase64() -> String {
        let data = NSData.init(base64EncodedString: self, options: []) ?? NSData()
        return String(data: data, encoding: NSUTF8StringEncoding) ?? ""
    }
    
    func aesEncryptWithoutPaddingWithStaticIV(key: String, iv: String) -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        let enc = try! AES(key: key, iv: iv, blockMode:.ECB).encrypt(data!.arrayOfBytes())
        
        let encData = NSData(bytes: enc, length: Int(enc.count))
        let base64String: String = encData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
        let result = String(base64String)
        return result
    }
    
    func aesDecryptWithoutPaddingWithStaticIV(key: String, iv: String) -> String {
        let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
        let dec = try! AES(key: key, iv: iv, blockMode:.ECB).decrypt(data!.arrayOfBytes())
        let decData = NSData(bytes: dec, length: Int(dec.count))
        let result = NSString(data: decData, encoding: NSUTF8StringEncoding)
        return String(result!)
    }
    
    func aesEncrypt(key: String) -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let keyData = key.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!.arrayOfBytes()
        let ivData = AES.randomIV(keyData.count)
        let encrypted = try! AES(key: keyData, iv: ivData, blockMode:.ECB).encrypt(data!.arrayOfBytes())
        let encryptedData = NSData(bytes: encrypted, length: Int(encrypted.count))
        let sendData = NSMutableData(bytes: ivData, length: Int(ivData.count))
        sendData.appendData(encryptedData)
        let base64String: String = sendData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
        let result = String(base64String)
        return result
        
    }
    
    func aesDecrypt(key: String) -> String {
        let data = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
        let keyData = key.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!.arrayOfBytes()
        let ivData = data!.subdataWithRange(NSRange(location: 0, length: AES.blockSize)).arrayOfBytes()
        let encryptedData = data!.subdataWithRange(NSRange(location: AES.blockSize, length: (data!.length - AES.blockSize) as Int))
        let decrypted = try! AES(key: keyData, iv: ivData, blockMode:.CBC).decrypt(encryptedData.arrayOfBytes())
        let decryptedData = NSData(bytes: decrypted, length: Int(decrypted.count))
        let decryptedString = NSString(data: decryptedData, encoding: NSUTF8StringEncoding)!
        return String(decryptedString)
    }
    
}