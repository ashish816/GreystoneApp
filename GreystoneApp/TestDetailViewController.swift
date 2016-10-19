//
//  TestDetailViewController.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 6/14/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit
import Alamofire

class TestDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var testDetailTableView: UITableView!
    var testResultId : NSString?
    var stationId : NSString?
    var testResult : TestResultModel?
    var activityIndicator : UIActivityIndicatorView?
    var testResultKeys : NSArray = NSArray()
    var eraseTestResult: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let values = ["command" : "get-data-by-datetime","station_serial" : self.stationId!,"erase_id": self.testResultId as! String];
        GSActivityIndicatorView.showActivity(self.view, color: UIColor.darkGrayColor())
        
        ServiceConnector.retieveAllTestResults(values) { (response, error) in
                if let errorValue = error {
                    print("Error retrieving Result", errorValue)
                    
                }else {
                    self.parseResults(response as! String);
                }
        }
        
        var image = UIImage(named: "Setting.png")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Done, target: self, action: #selector(TestDetailViewController.openSettingPage))
        
    }
    
    func parseResults(resultString : String) {
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let decryptedString = resultString.aesDecryptWithoutPaddingWithStaticIV("uY7Gm3EPID8y3cHeJQtZyUS5xKHlVZSu", iv: "");
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
                
                let functionTest = testResultDic?.valueForKey("function_test");
                
                let obj:AnyObject? = try! NSJSONSerialization.JSONObjectWithData(functionTest!.dataUsingEncoding(NSUTF8StringEncoding)!, options:[])
                
                self.eraseTestResult = obj as! NSDictionary
                
                let testKeys = self.eraseTestResult.allKeys as NSArray
                let keysToDisplay : NSMutableArray = NSMutableArray()
                
                for aKey in testKeys {
                    if EraseResultConstants.arrayOfTests.contains(aKey as! String){
                        keysToDisplay.addObject(aKey)
                    }
                }
                
                self.testResultKeys = keysToDisplay
                
                dispatch_async(dispatch_get_main_queue(), {
                    GSActivityIndicatorView.hideActivity()
                    self.testDetailTableView.reloadData()
                })
        }
    }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testResultKeys.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell?
        
        if indexPath.row == 0 {
            
            let  currentCell = tableView.dequeueReusableCellWithIdentifier("DeviceInfoCell") as? StationViewCell
            currentCell!.imeiId.text = self.testResult!.imeiID
            currentCell!.productlabel.text = self.testResult!.productType
            currentCell!.serialNumber.text = self.testResult!.serialNumber
            
            cell = currentCell
            
        } else {
            
            let  currentCell  = tableView.dequeueReusableCellWithIdentifier("TestResultcell") as? EraseResultDisplayCell
            
            let currentkey = self.testResultKeys[indexPath.row-1] as! String
            let displayString = EraseResultConstants.testResultParametersMapping.valueForKey(currentkey) as! String
            
            currentCell!.keyText.text = displayString
            let testValue = self.eraseTestResult.valueForKey(currentkey)! as! String
            
            if testValue.lowercaseString == "n/a" || testValue.isEmpty ||
                currentkey == EraseResultConstants.testFirstFunction || currentkey == EraseResultConstants.testBatteryTest || currentkey == EraseResultConstants.testItem || currentkey == EraseResultConstants.testFucntionTestType || currentkey == EraseResultConstants.testTrackingId
                || currentkey == EraseResultConstants.testFunctionresult{
                currentCell!.valueText.text = "\(self.eraseTestResult.valueForKey(currentkey)!)"
            }else
            {
                
                let storedValue = EraseResultConstants.testResultValues.valueForKey(currentkey) as! String
                if testValue.lowercaseString == storedValue.lowercaseString  {
                    currentCell!.passFailedSignImageView.image = UIImage(named:"GREEN CHECK")
                    currentCell?.passFailedImageWidth.constant = 20;
                    currentCell?.passFailedImageWidth.constant = 18;
                    currentCell?.layoutIfNeeded()
                    currentCell!.valueText.text = ""
                } else {
                    currentCell!.passFailedSignImageView.image = UIImage(named:"RED X MARK")
                    currentCell?.passFailedImageWidth.constant = 17;
                    currentCell?.passFailedImageWidth.constant = 17;
                    currentCell?.layoutIfNeeded()
                    currentCell!.valueText.text = ""
                }
            }
            cell = currentCell
            
            if indexPath.row-1 == self.testResultKeys.count - 1 {
                cell?.roundedCorners(15, roundingCorners: [.BottomLeft, .BottomRight])
                cell?.setNeedsDisplay()
                cell?.setNeedsLayout()
            }
            
        }
        
        if indexPath.row % 2 == 0 {
            cell?.backgroundColor = UIColor.whiteColor()
        } else {
            cell?.backgroundColor = UIColor(netHex : 0xefeff3)
        }
    
        return cell!;
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        }
        return 44
    }

    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionLabel = GSRoundedCornerLabel()
  
            sectionLabel.text = "Device Result"
    
        sectionLabel.textColor = UIColor.whiteColor()
        sectionLabel.backgroundColor = UIColor(netHex : 0x7c8590)
        sectionLabel.textAlignment = NSTextAlignment.Center
        
        return sectionLabel
    }
    
    
    func openSettingPage() {
        let myStoryBoard:UIStoryboard = UIStoryboard(name:"Setting", bundle:nil)
        
        let settingViewController = myStoryBoard.instantiateViewControllerWithIdentifier("SettingVC") as! SettingViewController
        
        self.navigationController?.pushViewController(settingViewController, animated: true)
        
    }
    
    
    func showAlert(title : NSString, message : NSString) {
        let alertController = UIAlertController(title: title as String, message:message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
