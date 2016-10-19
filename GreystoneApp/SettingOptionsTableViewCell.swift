//
//  SettingOptionsTableViewCell.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 7/29/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

protocol SettingOptionCellDelegate : class {
    
    func didClickedActionButton(sender : UIButton, data : AnyObject?)
    
}

class SettingOptionsTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var actionButton : UIButton!
    @IBOutlet weak var firstNameField : GSTextField!
    @IBOutlet weak var lastNameField : GSTextField!
    @IBOutlet weak var emailfield : GSTextField!
    @IBOutlet weak var phoneField : GSTextField!

    var autoLoginEnabled : Bool?
    var firstName : String?
    var lastName : String?
    var email : String?
    var phoneNumber : String?
    
    var currentTextField : UITextField?
    
    weak var settionOptionDelegate : SettingOptionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setOptionProperties () {
        self.firstName = self.firstNameField.text
        self.lastName = self.lastNameField.text
        self.email = self.emailfield.text
        self.phoneNumber = self.phoneField.text
        self.firstNameField.leftTextMargin = 20;
        self.lastNameField.leftTextMargin = 20;
        self.emailfield.leftTextMargin = 20;
        self.phoneField.leftTextMargin = 20;
        self.layoutIfNeeded()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
         if textField.tag == 100 {
            self.firstName = textField.text
         }  else if textField.tag == 200 {
            self.lastName = textField.text
         } else if textField.tag == 300 {
            self.email = textField.text
         } else if textField.tag == 400 {
            self.phoneNumber = textField.text
         }
    }
    
    @IBAction func actionButtonClicked(sender : UIButton) {
        
        if self.currentTextField != nil {
            self.textFieldDidEndEditing(self.currentTextField!)
        }        
        if sender.tag == 100 {
            
            let userInfo = UserInfo(fname: self.firstName, lname: self.lastName, email: self.email, phone:  self.phoneNumber)
            
            self.settionOptionDelegate?.didClickedActionButton(sender, data: userInfo)
            
        } else if sender.tag == 200 {
            
            self.settionOptionDelegate?.didClickedActionButton(sender, data: nil)

            
        } else if sender.tag == 300 {
            self.settionOptionDelegate?.didClickedActionButton(sender, data: nil)

        }    
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    


}
