//
//  GSRoundedCornerView.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 7/26/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class GSRoundedCornerView: UIView {

    override func layoutSubviews() {
        self.roundedCorners(15, roundingCorners: [.BottomLeft, .BottomRight])
    }
}
