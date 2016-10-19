//
//  SettingViewController.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 7/15/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AutoLoginSettingDelegate, SettingOptionCellDelegate {
    
    @IBOutlet var settingTableView : UITableView!
    var autoLoginSwitchOn : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingTableView.layer.roundedCorners(15, roundingCorners: [.BottomLeft, .BottomRight])
        
        let autolOginEnabled: String? = KeychainWrapper.stringForKey("autologinenabled")
        if autolOginEnabled == "true" {
            self.autoLoginSwitchOn = true
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell?
        
        if indexPath.row == 0 {
             let currentCell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! SettingAutoLoginCellTableViewCell
            currentCell.autoLoginDelegate = self
            if self.autoLoginSwitchOn {
                currentCell.showSavedValues()
                currentCell.autoLoginSwitch.on = true
            }
            else{
                currentCell.autoLoginSwitch.on = false
            }
            cell = currentCell

        } else if indexPath.row == 1{
            
            let cellIdentifier = "cell"+"\(indexPath.row+1)"
            
            let currentCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingOptionsTableViewCell
            
            if let userInfo = self.loadContact() as? UserInfo {
                
                let fname = userInfo.firstName
                let lname = userInfo.lastName
                let email = userInfo.emailAddress
                let phone = userInfo.phoneNumber
                
                if fname != nil {
                    currentCell.firstNameField.text = fname!;

                }
                if lname != nil {
                    currentCell.lastNameField.text = lname!;
                    
                }
                if email != nil {
                    currentCell.emailfield.text = email!;
                    
                }
                if phone != nil {
                    currentCell.phoneField.text = phone!;
                }
                
                currentCell.setOptionProperties()
            }
            currentCell.settionOptionDelegate = self;

            cell = currentCell
            
        } else {
            let cellIdentifier = "cell"+"\(indexPath.row+1)"
            
            let currentCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingOptionsTableViewCell
            
            currentCell.settionOptionDelegate = self;
            
            cell = currentCell
        }
        return cell!
        
    }
    
    func loadContact() -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(UserInfo.ArchiveURL.path!)
    }
    
    @IBAction func closeModalView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionLabel = GSRoundedCornerLabel()

        if section == 0  {
           sectionLabel.text = "Options"
            sectionLabel.textColor = UIColor.whiteColor()
            sectionLabel.backgroundColor = UIColor(netHex : 0x7c8590)
            sectionLabel.textAlignment = NSTextAlignment.Center
            
        }
        return sectionLabel
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if self.autoLoginSwitchOn {
                return 215
            }else{
                return 115
            }
        } else if indexPath.row == 1 {
            return 330

        } else if indexPath.row == 2 {
            return 120
            
        }
        else if indexPath.row == 3 {
            return 84
            
        }
        return 0
    }
    
    func clickedAutoLogin(sender : UISwitch){
        
        self.autoLoginSwitchOn = sender.on
        
        let indexPath1 = NSIndexPath(forRow: 0, inSection: 0)
        self.settingTableView.reloadRowsAtIndexPaths([indexPath1], withRowAnimation:UITableViewRowAnimation.Fade)
        
    }
    
//    func manageAlertCellButtonClicked(sender : UIButton) {
//        if sender.tag == 201 {
//            self.saveContact()
//        } else if sender.tag == 202 {
//            self.manageAlert()
//            
//        }else if sender.tag == 203 {
//            self.logOut()
//        }
//    }
    
    func saveContact(data : AnyObject?) {
        
        let userInfo = data as? UserInfo
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(userInfo!, toFile: UserInfo.ArchiveURL.path!)
        
        if isSuccessfulSave {
            self.showAlert("Successful", message: "Contact Saved Successfully!")
        }
        
        if !isSuccessfulSave {
            print("Failed to save contact...")
        }
    }
    
    func manageAlert() {
        self.performSegueWithIdentifier("ManagerAlertIdentifier", sender: nil)
    }
    
    func logOut() {
        
        KeychainWrapper.setString("false", forKey: "autologinenabled")
        
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let signInPage =
        storyBoard.instantiateInitialViewController() as! LoginViewController
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = signInPage
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ManagerAlertIdentifier" {
            let destinationViewController = segue.destinationViewController as! ManageAlertsViewController
        }
    }
    
    func didClickedActionButton(sender : UIButton, data : AnyObject?){
    
        if sender.tag == 100 {
            
            self.saveContact(data)
            
        } else if sender.tag == 200 {
            
            self.manageAlert()
            
        } else if sender.tag == 300 {
            
            self.logOut()
            
        }
        
    }
    func showAlert(title : NSString, message : NSString) {
        let alertController = UIAlertController(title: title as String, message:message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
