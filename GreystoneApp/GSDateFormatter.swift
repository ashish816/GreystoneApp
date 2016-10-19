//
//  GSDateFormatter.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 6/23/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class GSDateFormatter: NSDateFormatter {
    
    static let shareInstance = NSDateFormatter()
    let currentDate = NSDate()
    
    class func stringFromDate(date: NSDate) -> String {
        shareInstance.dateFormat = "YYYY-MM-dd HH:mm:ss"
        shareInstance.timeZone = NSTimeZone(name: "UTC");
        return shareInstance.stringFromDate(date)
    }
    
    class func stringFromCurrentDate() -> String {
        let currentDate = NSDate()
        shareInstance.dateFormat = "YYYY-MM-dd HH:mm:ss"
        shareInstance.timeZone = NSTimeZone(name: "UTC");
        return shareInstance.stringFromDate(currentDate)
    }
    
    class func stringFromYesterdayDate ()-> String{
        let dayComponent = NSDateComponents()
        dayComponent.day = -1;
        let calendarComponent = NSCalendar.currentCalendar()
        let aDayPriorDate = calendarComponent.dateByAddingComponents(dayComponent, toDate: NSDate(), options:[])
        return  shareInstance.stringFromDate(aDayPriorDate!)
    }
    
    class func stringFromPastDate (numberOfDaysInpast :Int)-> String{
        let dayComponent = NSDateComponents()
        dayComponent.day = -numberOfDaysInpast;
        let calendarComponent = NSCalendar.currentCalendar()
        let aDayPriorDate = calendarComponent.dateByAddingComponents(dayComponent, toDate: NSDate(), options:[])
        return  shareInstance.stringFromDate(aDayPriorDate!)
    }
    
    
    
    
    
}
