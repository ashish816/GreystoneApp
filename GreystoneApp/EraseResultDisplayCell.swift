//
//  EraseResultDisplayCell.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 6/14/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class EraseResultDisplayCell: UITableViewCell {

    @IBOutlet var keyText : UILabel!
    @IBOutlet var valueText: UILabel!
    @IBOutlet var passFailedImageHeight : NSLayoutConstraint!
    @IBOutlet var passFailedImageWidth : NSLayoutConstraint!
    @IBOutlet var passFailedSignImageView : UIImageView!
    
    
    override func prepareForReuse() {
        self.keyText.text = "";
        self.valueText.text = "";
        self.passFailedSignImageView.image = nil
    }

}
