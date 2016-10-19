//
//  ViewController.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 6/1/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift
import SwiftyJSON

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var StationtableView : UITableView!
    var fethedEraseResults : NSMutableArray? = NSMutableArray()
    var currentSegmentResults : NSMutableArray? = NSMutableArray()
    var passedResults : NSMutableArray?
    var failedResults : NSMutableArray?
    var activityIndicator : UIActivityIndicatorView?
    var stationID : NSString?
    var currentDateString : NSString?
    var aDayPriorDateString : NSString?
    var tableViewPassedResultsMode : Bool?
    var failedReasonWithDevices : NSMutableDictionary?
    
    @IBOutlet var segmentedControl : UISegmentedControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableViewPassedResultsMode = true;
        
        self.currentDateString = GSDateFormatter.stringFromCurrentDate()
        self.aDayPriorDateString = GSDateFormatter.stringFromPastDate(1)
       
        let values = ["command" : "get-data-by-datetime","station_serial" : self.stationID!,"from_datetime" :aDayPriorDateString as! String , "to_datetime" :currentDateString as! String ];

        GSActivityIndicatorView.showActivity(self.view, color: UIColor.darkGrayColor())
        
        ServiceConnector.retieveAllTestResults(values) { (response, error) in
            if let errorValue = error {
                print("Error retrieving Result", errorValue)
                
            }else {
                self.parseResults(response as! String);
            }
        }
        
    }
    
    @IBAction func indexChanged(sender:UISegmentedControl){
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.currentSegmentResults = self.passedResults
            self.tableViewPassedResultsMode = true
            self.StationtableView?.reloadData()
        case 1:
            self.currentSegmentResults = self.failedResults
            self.tableViewPassedResultsMode = false
            self.StationtableView?.reloadData()
        default:
            break;
        }
    }
    
    func parseResults(resultString : String) {
        
        self.passedResults = NSMutableArray();
        self.failedResults = NSMutableArray();
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let decryptedString = resultString.aesDecryptWithoutPaddingWithStaticIV("uY7Gm3EPID8y3cHeJQtZyUS5xKHlVZSu", iv: "");
            let set = NSCharacterSet(charactersInString: "\\,.?,\\x00..\\x1F, \t.,\0")
            let result = decryptedString.stringByTrimmingCharactersInSet(set)
            
            let obj:AnyObject? = try! NSJSONSerialization.JSONObjectWithData(result.dataUsingEncoding(NSUTF8StringEncoding)!, options:[])
            if let eraseResults = obj as? NSDictionary {
                
                self.fethedEraseResults = NSMutableArray()
                
                let eraseInfoObjects = eraseResults.valueForKey("data") as! NSArray;
                
                let failedIds = NSMutableArray()
                
                for eraseInfo in eraseInfoObjects {
                    let anEraseInfo = eraseInfo as! NSDictionary
                    let eraseDetail = EraseDetail()
                    eraseDetail.eraseId = anEraseInfo.valueForKey("id") as? NSString;
                    
                    eraseDetail.eraseStatus = anEraseInfo.valueForKey("status") as? NSString;
                    eraseDetail.eraseDateTime = anEraseInfo.valueForKey("erase_datetime") as? NSString;
                    eraseDetail.eraseIMEI = anEraseInfo.valueForKey("erase_imei") as? NSString;
                    eraseDetail.deviceManufacturer = anEraseInfo.valueForKey("device_manufacturer") as? NSString;
                    eraseDetail.deviceCarrier = anEraseInfo.valueForKey("device_carrier") as? NSString;
                    eraseDetail.eraseMethod = anEraseInfo.valueForKey("erase_method") as? NSString;
                    eraseDetail.customername = anEraseInfo.valueForKey("customer_name") as? NSString;
                    eraseDetail.deviceWiFiAddress = anEraseInfo.valueForKey("device_wifi_address") as? NSString;
                    eraseDetail.deviceBluetoothAddress = anEraseInfo.valueForKey("device_bluetooth_address") as? NSString;
                    eraseDetail.deviceModelNo = anEraseInfo.valueForKey("device_model_number") as? NSString;
                    eraseDetail.deviceColor = anEraseInfo.valueForKey("device_color") as? NSString;
                    eraseDetail.deviceOSType = anEraseInfo.valueForKey("device_os_type") as? NSString;
                    eraseDetail.deviceSn = anEraseInfo.valueForKey("sn") as? NSString;
                    eraseDetail.processType = anEraseInfo.valueForKey("process_type") as? NSString;
                    eraseDetail.functionTest = anEraseInfo.valueForKey("function_test") as? NSString;
                    eraseDetail.productName = anEraseInfo.valueForKey("product") as? NSString;
                    
                    
                    eraseDetail.testResults = anEraseInfo.valueForKey("function_test") as? NSDictionary;
                    
                    if let eraseStatus = eraseDetail.eraseStatus {
                        
                        if eraseStatus == "0"{
                            self.passedResults!.addObject(eraseDetail)
                            
                        }else {
                            self.failedResults!.addObject(eraseDetail)
                            failedIds.addObject(eraseDetail.eraseId!)
                        }
                    }
                    self.fethedEraseResults!.addObject(eraseDetail)
                }
                
                self.fetchResultsForFailedTests(failedIds)
                
            }
        }
    }
    
    func fetchResultsForFailedTests(failedIds : NSArray) {
        
        let values = ["command" : "get-data-by-datetime","station_serial" : self.stationID!, "erase_id" : failedIds];
        
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
                
                let eraseInfoObjects = eraseResults.valueForKey("data") as! NSArray;
                
                self.failedReasonWithDevices = NSMutableDictionary()
                
                for aFailedTest in eraseInfoObjects {
                    
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
                        
                        if(aTestParameter == EraseResultConstants.testFucntionTestType){
                            
                            print(testParamaterResult)
                        }
                        if (aTestParameter == EraseResultConstants.testDevicePasscode && testParamaterResult.lowercaseString == "no" || aTestParameter == EraseResultConstants.testLitmuspaper && testParamaterResult.lowercaseString == "no" || aTestParameter == EraseResultConstants.testCheckEngrave && testParamaterResult.lowercaseString == "no" || aTestParameter == EraseResultConstants.testDeviceNumber && testParamaterResult.lowercaseString == "no" || aTestParameter == EraseResultConstants.testCarrierActive && testParamaterResult.lowercaseString == "no" || aTestParameter == EraseResultConstants.testLcdCracked && testParamaterResult.lowercaseString == "no" || aTestParameter == EraseResultConstants.testFucntionTestType && testParamaterResult.lowercaseString == ""){
                            continue;
                        }
                        
                        if (aTestParameter == EraseResultConstants.testLcdCracked && testParamaterResult.lowercaseString == "yes") || (aTestParameter == EraseResultConstants.testCheckEngrave && testParamaterResult.lowercaseString == "yes") {
                            counterForNotAvailable += 1;
                            let deviceSerialNumber = aFailedTest.valueForKey("device_sn") as? String
                            self.setFailedDevicesForTest(aTestParameter, deviceSerial: deviceSerialNumber)
                        } else if  testParamaterResult.lowercaseString == "failed" || testParamaterResult.lowercaseString == "no" {
                            counterForNotAvailable += 1;
                            let deviceSerialNumber = aFailedTest.valueForKey("device_sn") as? String
                            self.setFailedDevicesForTest(aTestParameter, deviceSerial: deviceSerialNumber)
                            
                        }
                        
                        if counterForNotAvailable == 0 && counterForParameters == allTestParameters.count  {
                            let deviceSerialNumber = aFailedTest.valueForKey("device_sn") as? String
                            self.setFailedDevicesForTest("No Test Performed", deviceSerial: deviceSerialNumber)
                        }
                        
                    }
                    
                }
                
                print(self.failedReasonWithDevices)
                
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                //                    self.StationtableView!.reloadData()
                self.segmentedControl.hidden = false;
                self.segmentedControl.setTitle("Passed: \(self.passedResults!.count)", forSegmentAtIndex: 0)
                self.segmentedControl.setTitle("Failed: \(self.failedResults!.count)", forSegmentAtIndex: 1)
                
                self.segmentedControl.selectedSegmentIndex = 0;
                self.segmentedControl.selectedSegmentIndex = 1;
                
                self.indexChanged(self.segmentedControl)
                GSActivityIndicatorView.hideActivity()
            })
        }
    }
    
    func setFailedDevicesForTest(testParameter : NSString?, deviceSerial : NSString?) {
        if let failedDevices = self.failedReasonWithDevices!.valueForKey(testParameter as! String) as? NSArray {
            let newFailedDevices = failedDevices.mutableCopy() as! NSMutableArray
            let deviceSerialNumber = deviceSerial!
            newFailedDevices.addObject(deviceSerialNumber)
            self.failedReasonWithDevices!.setObject(newFailedDevices, forKey:testParameter!)
            
        }
        else {
            let deviceSerialNumber = deviceSerial!
            let devices = [deviceSerialNumber];
            self.failedReasonWithDevices!.setObject(devices, forKey:testParameter!)
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier: String = "StationCell"
        
        let cell: StationViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as! StationViewCell
        
        if !self.tableViewPassedResultsMode! {
            
            let allKeys = self.failedReasonWithDevices?.allKeys
            let currentkey = allKeys![indexPath.section]
            let allResultsForKey = self.failedReasonWithDevices?.valueForKey(currentkey as! String) as! NSArray
            let serialNumber = allResultsForKey[indexPath.row] as? String
            if let eraseObject = self.getEraseObject(serialNumber!){
                
                cell.productlabel.text = eraseObject.productName as? String
                cell.serialNumber.text = eraseObject.deviceSn as? String
                cell.eraseId.text = ""
                cell.status.textColor = UIColor.redColor()
                cell.status.text = "Failed"
            }
            
        } else {
            
            let eraseDetail = self.currentSegmentResults![indexPath.row] as? EraseDetail;
            
            if eraseDetail != nil {
                
                if let eraseId = eraseDetail!.eraseId {
                    cell.eraseId.text = (eraseId as String) as String
                }
                if let eraseStatus = eraseDetail!.eraseStatus {
                    
                    if eraseStatus == "0"{
                        cell.status.textColor = UIColor.greenColor()
                        cell.status.text = "Passed"
                        
                    }else {
                        cell.status.textColor = UIColor.redColor()
                        cell.status.text = "Failed"
                        
                    }
                }
                
            }
            
            cell.productlabel.text = eraseDetail?.productName as? String
            cell.serialNumber.text = eraseDetail?.deviceSn as? String
        }
        
        return cell
    }
    
    func getEraseObject(serilNumber : String)-> AnyObject? {
        
        for aObj in self.failedResults! {
            let aFailedResult = aObj as! EraseDetail
            if aFailedResult.deviceSn! == serilNumber {
                return aFailedResult
            }
        }
        return nil;
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("TestResultDetail", sender: indexPath)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if !self.tableViewPassedResultsMode! {
            return (self.failedReasonWithDevices?.allKeys.count)!
        }
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if !self.tableViewPassedResultsMode! {
            let allKeys = self.failedReasonWithDevices?.allKeys
            let currentkey = allKeys![section]
            let numberOfRowsInSection = self.failedReasonWithDevices?.valueForKey(currentkey as! String)
            let displayString = EraseResultConstants.testResultParametersMapping.objectForKey((allKeys![section] as? String)!);
            return displayString as! String+" \((numberOfRowsInSection as? NSArray)!.count)"
        }
        return ""
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !self.tableViewPassedResultsMode! {
            let allKeys = self.failedReasonWithDevices?.allKeys
            let currentkey = allKeys![section]
            let numberOfRowsInSection = self.failedReasonWithDevices?.valueForKey(currentkey as! String)
            
            return (numberOfRowsInSection as? NSArray)!.count
        }
        
        return (self.currentSegmentResults?.count)!;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TestResultDetail" {
            let currentIndex = sender as! NSIndexPath;
            let currentTestId = (self.currentSegmentResults![currentIndex.row] as! EraseDetail).eraseId
            let testDetailViewController = segue.destinationViewController as! TestDetailViewController
            testDetailViewController.testResultId = currentTestId
            testDetailViewController.stationId = self.stationID
        }
    }
}
