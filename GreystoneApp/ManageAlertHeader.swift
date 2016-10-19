//
//  ManageAlertHeader.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 8/1/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class ManageAlertHeader: UIView {
    
    @IBOutlet weak var machineNumber: UILabel!
    @IBOutlet weak var expandButton: GSButton!
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ManageAlertHeader", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }

}
