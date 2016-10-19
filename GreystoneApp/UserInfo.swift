//
//  UserInfo.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 8/17/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class UserInfo: NSObject, NSCoding {
    
    var firstName : String?
    var lastName : String?
    var emailAddress : String?
    var phoneNumber : String?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("userinfo")
    
    // MARK: Types
    
    struct PropertyKey {
        static let firstName = "firstname"
        static let lastName = "lastname"
        static let emailAddress = "email"
        static let phoneNumber = "phone"
//        static let isAutoLoginEnabled = "isAutoLoginEnabled"

    }
    
    // MARK: Initialization
    
    init?(fname: String?, lname: String?, email: String?, phone : String?) {
        // Initialize stored properties.
        self.firstName = fname
        self.lastName = lname
        self.emailAddress = email
        self.phoneNumber = phone
        super.init()

    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(firstName, forKey: PropertyKey.firstName)
        aCoder.encodeObject(lastName, forKey: PropertyKey.lastName)
        aCoder.encodeObject(emailAddress, forKey: PropertyKey.emailAddress)
        aCoder.encodeObject(phoneNumber, forKey: PropertyKey.phoneNumber)

    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let fname = aDecoder.decodeObjectForKey(PropertyKey.firstName) as? String
        
        let lname = aDecoder.decodeObjectForKey(PropertyKey.lastName) as? String
        
        let email = aDecoder.decodeObjectForKey(PropertyKey.emailAddress) as? String
        
        let phone = aDecoder.decodeObjectForKey(PropertyKey.phoneNumber) as? String
    
        self.init(fname: fname, lname: lname, email: email, phone : phone)
    }

}
