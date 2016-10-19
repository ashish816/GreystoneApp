//
//  LoginViewController.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 6/24/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var PasswordContainer : UIView!
    @IBOutlet var loginContainer : UIView!
    
    @IBOutlet var loginField : GSTextField!
    @IBOutlet var passwordField : GSTextField!

    @IBOutlet weak var greystoneLogo: UIImageView!
    
    @IBOutlet weak var topLayoutConstraint : NSLayoutConstraint!
    
    var currentTextField : UITextField = UITextField()
    var techSupport : TechSupportInfo?
    
    var isKeyboardPresent : Bool?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.loginContainer.layer.setBorderColorFromUIcolor(UIColor(netHex : 0xd9d9d8))
//        self.PasswordContainer.layer.setBorderColorFromUIcolor(UIColor(netHex : 0xd9d9d8))
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
        self.loginField.attributedPlaceholder = NSAttributedString(string:"Username",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        self.passwordField.attributedPlaceholder = NSAttributedString(string:"Password",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        self.loginField.leftTextMargin = 30;
        self.passwordField.leftTextMargin = 30;
        self.loginField.layoutIfNeeded()
        self.passwordField.layoutIfNeeded()
        
        //self.retrivevaluesFromkeychain()
        
        self.autoLoginIfEnabled()
        
    }
    
    func autoLoginIfEnabled() {
        let autologinEnabled: String? = KeychainWrapper.stringForKey("autologinenabled")
        
        if autologinEnabled == "true"{
            self.retrivevaluesFromkeychain()
            self.validateCredentials()
        } else {
            
        }
    }
    
    func retrivevaluesFromkeychain() {
        let retrievedUsername: String? = KeychainWrapper.stringForKey("username")
        let retrievedPwd: String? = KeychainWrapper.stringForKey("pwd")
        
        if retrievedUsername != nil && retrievedPwd != nil {
            self.loginField.text = retrievedUsername!
            self.passwordField.text = retrievedPwd!
        }
    }
    
    func keyboardWillShow(notification:NSNotification){
        
        if self.isKeyboardPresent == true {
            return
        }
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        self.topLayoutConstraint.constant -= keyboardFrame.height
        self.isKeyboardPresent = true
    }
    
    func keyboardWillHide(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        self.topLayoutConstraint.constant += keyboardFrame.height
        self.isKeyboardPresent = false
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        self.currentTextField = textField
        
        if self.currentTextField.isFirstResponder() {
             self.currentTextField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
         textField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginClicked(sender : UIButton) {
        
        self.validateCredentials()
//        self.presentScanController()
    }
    
    func validateCredentials() {
        
        let scale = Int(UIScreen.mainScreen().scale)
        let resoltion = "x"+String(scale)
        
        let values = ["command" : "login", "username" : self.loginField.text!, "password" :self.passwordField.text!, "resolution" :resoltion];
        
        GSActivityIndicatorView.showActivity(self.view, color: UIColor.whiteColor())
        
        ServiceConnector.validateLogin(values) { (response, error) in
            if let errorValue = error {
                print("Error retrieving Result", errorValue)
                
            }else {
                self.parseResults(response as! String);
            }
        }
        
    }
    
    func parseResults(resultString : String) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let decryptedString = resultString.aesDecryptWithoutPaddingWithStaticIV("uY7Gm3EPID8y3cHeJQtZyUS5xKHlVZSu", iv: "");
            let set = NSCharacterSet(charactersInString: "\\,.?,\\x00..\\x1F, \t.,\0")
            let result = decryptedString.stringByTrimmingCharactersInSet(set)
            
            let obj:AnyObject? = try! NSJSONSerialization.JSONObjectWithData(result.dataUsingEncoding(NSUTF8StringEncoding)!, options:[])
            
            var loginFailed : Bool = false
            
            if let loginInfo = obj as? NSDictionary {
                
                let result = loginInfo.valueForKey("result") as? String
                
                if result?.lowercaseString == "success" {
                    
                    loginFailed = false
                    
                    let infoDic = loginInfo.valueForKey("supports") as! NSDictionary
                    
                    let techSupport = TechSupportInfo()
                    techSupport.techSupportMail = infoDic.valueForKey("sp_email") as? String
                    techSupport.techSupportName = infoDic.valueForKey("sp_name") as? String
                    techSupport.techSupportPhone = infoDic.valueForKey("sp_phone") as? String
                    
                    let imageDataString = infoDic.valueForKey("sp_image") as! String
                    techSupport.techSupportImageUrl = imageDataString
                    
                    self.techSupport = techSupport
                    
                } else {
                    
                    loginFailed = true
                    
                }
            }
                
                dispatch_async(dispatch_get_main_queue(), {
                    GSActivityIndicatorView.hideActivity()
                    if loginFailed {
                        self.currentTextField.resignFirstResponder()
                        self.showAlert("Invalid Credentials", message: "Please try again.")

                    } else {
                        self.saveLoginCredentialsToKeychain(UIButton());

                        self.presentScanController()
                    }
                })
            }
        }
    
     @IBAction func saveLoginCredentialsToKeychain(sender : UIButton) {
        
        if (self.loginField.text?.isEmpty == true || self.passwordField.text?.isEmpty == true){
            return
        }
        
            let usernameSaved: Bool = KeychainWrapper.setString(self.loginField.text!, forKey: "username")
            let pwdSaved: Bool = KeychainWrapper.setString(self.passwordField.text!, forKey: "pwd")
            
//            if usernameSaved && pwdSaved {
//                self.showAlert("Successful", message: "credential saved")
//            }
        
    }
    
    func presentScanController() {
        let myStoryBoard:UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        
        let afterSignInTabbarController : UITabBarController=myStoryBoard.instantiateViewControllerWithIdentifier("AfterSignInTabBar") as! UITabBarController
        afterSignInTabbarController.selectedIndex = 0;
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController = afterSignInTabbarController
        
        let navigationController = afterSignInTabbarController.selectedViewController as! UINavigationController
        let scanVC = navigationController.topViewController as! ScanController
        scanVC.techSupport = self.techSupport
    }
    
    func showAlert(title : NSString, message : NSString) {
        let alertController = UIAlertController(title: title as String, message:message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
