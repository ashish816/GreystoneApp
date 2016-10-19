//
//  ManageAlertCustomViewCell.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 7/29/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class ManageAlertCustomViewCell: UITableViewCell {
    
    @IBOutlet weak var machinNumber : UILabel!
    @IBOutlet weak var arrowButton : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    @IBAction func expandCellForSettingAlert() {
        
        self.arrowButton.selected = !self.arrowButton.selected
        
        if self.arrowButton.selected {
            
            let image = UIImage(named : "Arrow 3")
            
            self.arrowButton.setImage(image, forState: UIControlState.Normal)
        }
        else {
            let image = UIImage(named : "Arrow Selected")
            self.arrowButton.setImage(image, forState: UIControlState.Normal)

        }
        
    }

}
