//
//  GSRoundedCornerLabel.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 7/14/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class GSRoundedCornerLabel: UILabel {
    
    override func layoutSubviews() {
        self.roundedCorners(15)
        self.applyGradient(self, text: self.text!)
    }
    
    func applyGradient(label : UILabel, text : String) {

        
        label.backgroundColor = UIColor .clearColor()
        label.frame = label.bounds
        
        let gradientLayer = CAGradientLayer()
        // 2
        gradientLayer.frame = label.frame
        
        // 3
        let color1 = UIColor(netHex : 0x7C8083).CGColor as CGColorRef
        let color2 = UIColor(netHex: 0x46494C).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2]
        
        // 4
        gradientLayer.locations = [0.0,1.0]
        
        label.layer.addSublayer(gradientLayer)
        
        let textlabel = UILabel()
        textlabel.text = text
        textlabel.textColor = UIColor.whiteColor()
        textlabel.textAlignment = NSTextAlignment.Center
        textlabel.font = UIFont(name: ".HelveticaNeueDeskInterface-Bold", size: 17)!
        
        textlabel.frame = label.frame
        label.addSubview(textlabel)
        
    }
    
}
