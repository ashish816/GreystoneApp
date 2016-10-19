//
//  ServiceConnector.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 6/14/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit
import Alamofire

class ServiceConnector: NSObject {
    
    class func retieveAllTestResults(parameters : NSDictionary, completionHandler : (response : AnyObject?, error : NSError?) -> () ){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://cloud3.greystonedatatech.com/ZyFKGCxsc2h7N8XnCJhf8VLhdazrYgwt6aHN8QAp/public/station")!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(parameters, options:[])
        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        let encodedTring = jsonString.aesEncryptWithoutPaddingWithStaticIV("uY7Gm3EPID8y3cHeJQtZyUS5xKHlVZSu", iv: "");
        let bodyStr:String = encodedTring
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        
        Alamofire.request(request)
            .responseString { response in
                // do whatever you want here
                switch response.result {
                case .Failure(let error):
                    print(response)
                    completionHandler(response: nil, error: error)
                    
                case .Success(let responseObject):
                    print(responseObject)
                    completionHandler(response: responseObject, error: nil)
                }
        }
        
    }
    
    class func validateLogin(parameters : NSDictionary, completionHandler : (response : AnyObject?, error : NSError?) -> ()){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://cloud3.greystonedatatech.com/ZyFKGCxsc2h7N8XnCJhf8VLhdazrYgwt6aHN8QAp/public/user")!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(parameters, options:[])
        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        let encodedTring = jsonString.aesEncryptWithoutPaddingWithStaticIV("uY7Gm3EPID8y3cHeJQtZyUS5xKHlVZSu", iv: "");
        let bodyStr:String = encodedTring
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        
        Alamofire.request(request)
            .responseString { response in
                // do whatever you want here
                switch response.result {
                case .Failure(let error):
                    print(response)
                    completionHandler(response: nil, error: error)
                case .Success(let responseObject):
                    print(responseObject)
                    completionHandler(response: responseObject, error: nil)
                }
        }
        
    }
    
    class func sendGdtAlert(parameters : NSDictionary, completionHandler : (response : AnyObject?, error : NSError?) -> () ){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://cloud3.greystonedatatech.com/ZyFKGCxsc2h7N8XnCJhf8VLhdazrYgwt6aHN8QAp/public/station")!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(parameters, options:[])
        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        let encodedTring = jsonString.aesEncryptWithoutPaddingWithStaticIV("uY7Gm3EPID8y3cHeJQtZyUS5xKHlVZSu", iv: "");
        let bodyStr:String = encodedTring
        request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
        
        Alamofire.request(request)
            .responseString { response in
                // do whatever you want here
                switch response.result {
                case .Failure(let error):
                    print(response)
                    completionHandler(response: nil, error: error)
                    
                case .Success(let responseObject):
                    print(responseObject)
                    completionHandler(response: responseObject, error: nil)
                }
        }
        
    }
}
