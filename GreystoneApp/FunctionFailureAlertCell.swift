//
//  FunctionFailureAlertCell.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 8/1/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class FunctionFailureAlertCell: UITableViewCell {

    @IBOutlet weak var failureType : UILabel!
    @IBOutlet weak var onOffSwitch : UISwitch!

    override func prepareForReuse() {
        self.onOffSwitch.on = false
    }

}
