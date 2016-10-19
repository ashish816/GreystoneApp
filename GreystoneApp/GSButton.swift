//
//  GSButton.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 8/4/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class GSButton: UIButton {
    @IBOutlet weak var expandButtonHeight : NSLayoutConstraint!
    @IBOutlet weak var expandButtonWidth : NSLayoutConstraint!
    
    func setExpandButtonConstraint(isCollapsed : Bool) {
        if isCollapsed {
            self.expandButtonWidth.constant = 15;
            self.expandButtonHeight.constant = 22;
            
            let buttonImage = UIImage(named: "Arrow 3")
            self.setImage(buttonImage, forState: UIControlState.Normal)
            
        } else {
            self.expandButtonWidth.constant = 22;
            self.expandButtonHeight.constant = 15;
            
            let buttonImage = UIImage(named: "Arrow Selected")
            self.setImage(buttonImage, forState: UIControlState.Normal)
        }
        self.setNeedsLayout()
    }

}
