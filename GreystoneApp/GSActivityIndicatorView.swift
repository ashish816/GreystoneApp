//
//  GSActivityIndicatorView.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 6/23/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class GSActivityIndicatorView: UIActivityIndicatorView {
    
    static let sharedInstance = GSActivityIndicatorView(activityIndicatorStyle : UIActivityIndicatorViewStyle.Gray)

    class func showActivity(superView : UIView , color : UIColor) {
        sharedInstance.color = color
        sharedInstance.center = superView.center;
        sharedInstance.hidesWhenStopped = true;
        superView.addSubview(sharedInstance)
        sharedInstance.startAnimating()
    }
    
    class func hideActivity() {
        sharedInstance.stopAnimating()
    }

}
