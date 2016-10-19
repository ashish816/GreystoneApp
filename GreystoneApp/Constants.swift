//
//  Constants.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 8/15/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import Foundation
struct MachineConstants {
    static let swVersion = "software_version"
    static let location = "location_name"
    static let teamViewerId = "tvid"
    static let firmwareVersion = "firmware_version"
    static let assignedDate = "date_assign"
    static let podId = "pod_id"
    static let userName = "username"
    static let lastLogin = "last_login"
    static let stationSerial = "station_serial"
    
    static let propertyLists = [swVersion,location,teamViewerId, firmwareVersion,assignedDate,podId, userName,lastLogin,stationSerial];
    
    
    static let displayParameter : NSDictionary =
        [ swVersion: "Software Version",
          location : "Location",
          teamViewerId : "TeamViewerId",
          firmwareVersion:"Firmware",
          assignedDate: "Date Assigned",
          podId : "Pod Id",
          userName : "Username",
          lastLogin : "Last Login",
          stationSerial: " Station Serial"];
}

struct OperatorConstants {
    
    static let username = "username"
    static let name = "name"
    static let country_id = "country_id"
    static let phone = "phone"
    static let email = "email"
    static let level = "level"
    static let company_name = "company_name"
    static let propertyLists = [username,name,country_id,phone,email, level,company_name];
    
    
    static let displayParameter : NSDictionary =
        [ username: "Username",
          name : "Name",
          country_id : "Country Id",
          phone:"Phone",
          email: "Email",
          level : "Level",
          company_name : "Company",
          ];
}