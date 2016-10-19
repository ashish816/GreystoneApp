//
//  GSTextField.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 8/11/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class GSTextField: UITextField {

    var leftTextMargin : CGFloat = 0.0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftTextMargin
        return newBounds
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftTextMargin
        return newBounds
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftTextMargin
        return newBounds
    }

}
