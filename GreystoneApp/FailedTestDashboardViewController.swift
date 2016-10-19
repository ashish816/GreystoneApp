//
//  FailedTestDashboardViewController.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 6/30/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class FailedTestDashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EraseResultDelegate {
    
    var failedTestIds : NSArray?
    var stationID : NSString?
    var failedResultsDeviceInfo : NSMutableArray?
    var failedReasonWithDevices : NSMutableDictionary?
    @IBOutlet var testsDetailTableView : UITableView!
    var sortedKeys : NSArray?
  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchResultsForFailedTests(self.failedTestIds!)
        self.title = "Device Fail"
        
        var image = UIImage(named: "Setting.png")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Done, target: self, action: #selector(DashboardViewController.openSettingPage))
        
    }
    
    func fetchResultsForFailedTests(failedIds : NSArray) {
        
        let values = ["command" : "get-data-by-datetime","station_serial" : self.stationID!, "erase_id" : failedIds];
        
        GSActivityIndicatorView.showActivity(self.view, color:UIColor.darkGrayColor())
        
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
                
                self.failedReasonWithDevices = NSMutableDictionary()
                
                for aFailedTest in eraseInfoObjects {
//                    
                    let testResult = TestResultModel()
                    testResult.imeiID = aFailedTest.valueForKey("erase_imei") as? String
                    testResult.serialNumber = aFailedTest.valueForKey("device_sn") as? String
                    testResult.productType = aFailedTest.valueForKey("product_name") as? String
                    testResult.eraseId = aFailedTest.valueForKey("id") as? String
                    
                    let functionTestString = (aFailedTest as! NSDictionary).valueForKey("function_test") as! String
                    
                    let functionTestDic = try! NSJSONSerialization.JSONObjectWithData(functionTestString.dataUsingEncoding(NSUTF8StringEncoding)!, options:[]) as! NSDictionary
                    
                    let allTestParameters = EraseResultConstants.arrayOfTests
                    
                    var counterForParameters = 1;
                    var counterForNotAvailable = 0;
                    
                    for aTestParameter in allTestParameters {
                        
                        
                        counterForParameters += 1
                        
                        
                        let allkeysFromResponse = functionTestDic.allKeys as NSArray
                        if (!allkeysFromResponse.containsObject(aTestParameter)){
                            continue;
                        }
                        
                        let testParamaterResult = functionTestDic.valueForKey(aTestParameter) as! String
                        print(aTestParameter)
                        print(testParamaterResult)

                        if(aTestParameter == EraseResultConstants.testFucntionTestType){
                            print(aTestParameter)
                            print(testParamaterResult)
                        }
                        if (aTestParameter == EraseResultConstants.testDevicePasscode && testParamaterResult.lowercaseString == "no" || aTestParameter == EraseResultConstants.testLitmuspaper && testParamaterResult.lowercaseString == "no" || aTestParameter == EraseResultConstants.testCheckEngrave && testParamaterResult.lowercaseString == "no" || aTestParameter == EraseResultConstants.testDeviceNumber && testParamaterResult.lowercaseString == "no" || aTestParameter == EraseResultConstants.testCarrierActive && testParamaterResult.lowercaseString == "no" || aTestParameter == EraseResultConstants.testLcdCracked && testParamaterResult.lowercaseString == "no" || aTestParameter == EraseResultConstants.testFucntionTestType && testParamaterResult.lowercaseString == ""){
                            continue;
                        }
                        
                        if (aTestParameter == EraseResultConstants.testLcdCracked && testParamaterResult.lowercaseString == "yes") || (aTestParameter == EraseResultConstants.testCheckEngrave && testParamaterResult.lowercaseString == "yes") {
                            counterForNotAvailable += 1;
                            self.setFailedDevicesForTest(aTestParameter, deviceInfo: testResult)
                        } else if  testParamaterResult.lowercaseString == "failed" || testParamaterResult.lowercaseString == "no" {
                            counterForNotAvailable += 1;
                            self.setFailedDevicesForTest(aTestParameter, deviceInfo: testResult)
                        }
                        
                        if counterForNotAvailable == 0 && counterForParameters == allTestParameters.count  {
                            self.setFailedDevicesForTest("No Test Performed", deviceInfo: testResult)
                        }
                        
                    }
                    
                }
                
                print(self.failedReasonWithDevices)
                
            }
            
            self.sortResultsBasedOnNumberOffailure(self.failedReasonWithDevices!)

            
            dispatch_async(dispatch_get_main_queue(), {
                self.testsDetailTableView.reloadData()
                GSActivityIndicatorView.hideActivity()
            })
        }
    }
    
    func sortResultsBasedOnNumberOffailure(failedReasonWithDevices : NSDictionary) {
        
        
        var myArr = Array(failedReasonWithDevices.allKeys)
        myArr.sortInPlace { (obj1, obj2) -> Bool in
            
            print(obj1)
            print(obj2)

            let firstArray = failedReasonWithDevices.valueForKey(obj1 as! String) as! NSArray
            let secondArray = failedReasonWithDevices.valueForKey(obj2 as! String) as! NSArray
             return firstArray.count > secondArray.count
        }
        
        self.sortedKeys = myArr
        
    }
    
    func setFailedDevicesForTest(testParameter : NSString?, deviceInfo : TestResultModel?) {
        if let failedDevices = self.failedReasonWithDevices!.valueForKey(testParameter as! String) as? NSArray {
            let newFailedDevices = failedDevices.mutableCopy() as! NSMutableArray
            let deviceSerialNumber = deviceInfo!
            newFailedDevices.addObject(deviceSerialNumber)
            self.failedReasonWithDevices!.setObject(newFailedDevices, forKey:testParameter!)
            
        }
        else {
            let deviceSerialNumber = deviceInfo!
            let devices = [deviceSerialNumber];
            self.failedReasonWithDevices!.setObject(devices, forKey:testParameter!)
            
        }
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0  {
            return 230
        } else {
         return 44
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell?
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let cellIdentifier: String = "ResultCountCardCell"
             let currentCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as! TestCountCardCell
            currentCell.eraseResultDelegate = self
            
            let countFailed = self.failedTestIds!.count
            currentCell.failedCount.text = String(countFailed)
            
            let eraseFailedCount = self.failedEraseResultCount()
            
            let eraseTitle = "Erase Fail: "+"\(eraseFailedCount)"
            
            currentCell.setErasuButtonTitle(eraseTitle)
            
            cell = currentCell
            
        } else {
            let cellIdentifier: String = "FailedTestCountCell"
             cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as UITableViewCell
            
            
            let allKeys = self.failedReasonWithDevices?.allKeys
            let currentkey = (self.sortedKeys![indexPath.row]) as! String
            let numberOfRowsInSection = self.failedReasonWithDevices?.valueForKey(currentkey )
            
            let displayString = EraseResultConstants.testResultParametersMapping.objectForKey(currentkey);
            cell?.textLabel?.text = displayString as? String;
            let failedCount = numberOfRowsInSection?.count!
            cell?.detailTextLabel?.text = "\(failedCount!)"
            
            if indexPath.row == (allKeys?.count)! - 1 {
                cell?.roundedCorners(15, roundingCorners: [.BottomLeft, .BottomRight])
                cell?.setNeedsDisplay()
                cell?.setNeedsLayout()
            }
            
        }
        return cell!
    }
    
    func failedEraseResultCount()-> Int{
        let numberOfRowsInSection = self.failedReasonWithDevices?.valueForKey(EraseResultConstants.testEraseStatus )
        if let failedCount = numberOfRowsInSection?.count{
            return failedCount
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 && indexPath.section == 0 {
            return
        }
        self.performSegueWithIdentifier("DeviceInfo", sender: indexPath)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionLabel = GSRoundedCornerLabel()
        if section == 0 {
            sectionLabel.text = "GDT ALL-IN-ONE"
        } else {
            sectionLabel.text = "Test List"
            
        }
        sectionLabel.textColor = UIColor.whiteColor()
        sectionLabel.backgroundColor = UIColor(netHex : 0x7c8590)
        sectionLabel.textAlignment = NSTextAlignment.Center
        
        let indexSet = NSIndexSet(index: section)
        
        self.testsDetailTableView.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.None)
        
//        self.applyGradient(sectionLabel, text: sectionLabel.text!)
        
        return sectionLabel
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
            
        } else if section == 1 {
            if let allKeys = self.failedReasonWithDevices?.allKeys {
            return allKeys.count
            }
        }
        return 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DeviceInfo" {
            
            var currentkey : String?
            var failedDevices : AnyObject?
            var reasonForFailure : String?
            
            if sender?.lowercaseString == "erase" {
                 currentkey = "function_erasestatus"
                 failedDevices = self.failedReasonWithDevices?.valueForKey(currentkey! )
                
                if failedDevices == nil || failedDevices?.count == 0 {
                    self.showAlert("No Data", message: "No results to display.")
                    return
                }
                
                 reasonForFailure = EraseResultConstants.testResultParametersMapping.objectForKey(currentkey!) as? String;
                
            } else {
            
            let currentIndexpath = sender as! NSIndexPath
//            let allKeys = self.failedReasonWithDevices?.allKeys
             currentkey = (self.sortedKeys![currentIndexpath.row]) as? String
             failedDevices = self.failedReasonWithDevices?.valueForKey(currentkey! )
            
             reasonForFailure = EraseResultConstants.testResultParametersMapping.objectForKey(currentkey!) as? String;
            }
                        let destinationVC = segue.destinationViewController as! TestDeviceInfoViewController
            destinationVC.stationId = self.stationID as? String
            destinationVC.faulureReason = reasonForFailure
            destinationVC.testedDevices = failedDevices as? NSArray
            destinationVC.showingResultsForPassed = false
            }
        }
    
    func clickedEraseResult(){
        
        let sender = "Erase"
        
        self.performSegueWithIdentifier("DeviceInfo", sender: sender)
    }

    func openSettingPage() {
        let myStoryBoard:UIStoryboard = UIStoryboard(name:"Setting", bundle:nil)
        
        let settingViewController = myStoryBoard.instantiateViewControllerWithIdentifier("SettingVC") as! SettingViewController
        
        //        settingViewController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        //        presentViewController(settingViewController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(settingViewController, animated: true)
        
    }
    
    //    override func viewWillAppear(animated: Bool) {
    //        self.segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
    //    }

    func showAlert(title : NSString, message : NSString) {
        let alertController = UIAlertController(title: title as String, message:message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
