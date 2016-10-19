//
//  MachineInfoViewController.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 7/18/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class MachineInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var stationID : String?
    
    var allKeys = NSArray()
    var allResults =  NSDictionary()
    
    @IBOutlet weak var machineInfoTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchMachineInfo()
    }
    
    func fetchMachineInfo() {
        
        let values = ["command" : "get-one","station_serial" : self.stationID!];
        
        GSActivityIndicatorView.showActivity(self.view, color: UIColor.darkGrayColor())
        
        ServiceConnector.retieveAllTestResults(values) { (response, error) in
            if let errorValue = error {
                print("Error retrieving Result", errorValue)
                
            }else {
                self.parseFailedTestResults(response as! String);
            }
        }
    }
    
    func parseFailedTestResults(responseString : String) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let decryptedString = responseString.aesDecryptWithoutPaddingWithStaticIV("uY7Gm3EPID8y3cHeJQtZyUS5xKHlVZSu", iv: "");
            let set = NSCharacterSet(charactersInString: "\\,.?,\\x00..\\x1F, \t.,\0")
            let result = decryptedString.stringByTrimmingCharactersInSet(set)
            
            let obj:AnyObject? = try! NSJSONSerialization.JSONObjectWithData(result.dataUsingEncoding(NSUTF8StringEncoding)!, options:[])
            if let eraseResults = obj as? NSDictionary {
                
                if eraseResults.valueForKey("data") == nil{
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.showAlert("Error", message: "There is some error.")
                        GSActivityIndicatorView.hideActivity()
                    })
                    return
                }
                
                let eraseInfoObjects = eraseResults.valueForKey("data") as! NSArray;
                let testResultDic = eraseInfoObjects.lastObject;
                
                self.allResults = testResultDic as! NSDictionary
                
                self.allKeys = MachineConstants.propertyLists
                                
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.machineInfoTableView.reloadData()
                GSActivityIndicatorView.hideActivity()
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.allKeys.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MachineTestResultcell", forIndexPath: indexPath) as? UITableViewCell
        
        let currentkey = self.allKeys[indexPath.row] as? String
        
        let currentParameter = MachineConstants.displayParameter.valueForKey(currentkey!) as? String
        
        if  currentParameter != nil{
            print(currentkey)
            cell!.textLabel!.text = currentParameter
            
            if let testValue = self.allResults.valueForKey(currentkey!) {
                cell?.detailTextLabel!.text = "\(testValue)"
            }
        }
        
        if indexPath.row % 2 == 0 {
            cell?.backgroundColor = UIColor.whiteColor()
        } else {
            cell?.backgroundColor = UIColor(netHex : 0xefeff3)
        }
        
        return cell!;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionLabel = GSRoundedCornerLabel()
        
        sectionLabel.text = "Machine Info"
        
        sectionLabel.textColor = UIColor.whiteColor()
        sectionLabel.backgroundColor = UIColor(netHex : 0x7c8590)
        sectionLabel.textAlignment = NSTextAlignment.Center
        
        return sectionLabel
    }
    
    func showAlert(title : NSString, message : NSString) {
        let alertController = UIAlertController(title: title as String, message:message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
