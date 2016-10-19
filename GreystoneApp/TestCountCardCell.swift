//
//  TestCountCardCell.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 6/30/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

protocol EraseResultDelegate: class {
    func clickedEraseResult()
}

class TestCountCardCell: UITableViewCell {

    @IBOutlet var failedCount : UILabel!
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var dayLabel : UILabel!
    @IBOutlet var testStatus : UILabel!
    @IBOutlet var eraseResultButton : UIButton!
    
    override func layoutSubviews() {
        self.roundedCorners(15, roundingCorners: [.BottomRight, .BottomLeft])
    }
    
    weak var eraseResultDelegate : EraseResultDelegate?
    
    @IBAction func eraseButtonClicked(sender : UIButton) {
        self.eraseResultDelegate?.clickedEraseResult()
    }
    
    func setErasuButtonTitle(title : String) {
        self.eraseResultButton.setTitle(title, forState: UIControlState.Normal)
        
    }
}


