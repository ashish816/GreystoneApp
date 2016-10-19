//
//  SettingAutoLoginCellTableViewCell.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 7/18/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

protocol AutoLoginSettingDelegate : class {
    
    func clickedAutoLogin(sender : UISwitch)
    
}

class SettingAutoLoginCellTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var autoLoginSwitch :UISwitch!
    @IBOutlet weak var userNameField : UITextField!
    @IBOutlet weak var passwordField : UITextField!
    weak var autoLoginDelegate : AutoLoginSettingDelegate?
    
    override func layoutSubviews() {
        self.userNameField.addTarget(self, action: #selector(SettingAutoLoginCellTableViewCell.textValueChanged), forControlEvents: UIControlEvents.EditingChanged)
        
        self.passwordField.addTarget(self, action: #selector(SettingAutoLoginCellTableViewCell.textValueChanged), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func textValueChanged(textField : UITextField) {
        
        if textField.tag == 100 {
            KeychainWrapper.setString(textField.text!, forKey: "username")
        }
        if textField.tag == 200 {
            KeychainWrapper.setString(textField.text!, forKey: "pwd")
        }
        
    }

    @IBAction func switchValueChanged(sender : UISwitch){
        
        if sender.on {
            KeychainWrapper.setString("true", forKey: "autologinenabled")
        } else {
            KeychainWrapper.setString("false", forKey: "autologinenabled")
        }
        self.autoLoginDelegate?.clickedAutoLogin(sender)
    }
    
    func showSavedValues() {
        
        let retrievedUsername: String? = KeychainWrapper.stringForKey("username")
        let retrievedPwd: String? = KeychainWrapper.stringForKey("pwd")
        
        if retrievedUsername != nil && retrievedPwd != nil {
            self.userNameField.text = retrievedUsername!
            self.passwordField.text = retrievedPwd!
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       return textField.resignFirstResponder()
    }
    
}
