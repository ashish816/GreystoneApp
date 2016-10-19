//
//  DashboardViewController.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 6/28/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var segmentedControlHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var labelContainer: GSRoundedCornerView!
    var stationID : String?
    
    var fethedEraseResults : NSMutableArray? = NSMutableArray()
    var currentSegmentResults : NSMutableArray? = NSMutableArray()
    var passedResults : NSMutableArray?
    var failedResults : NSMutableArray?
    var activityIndicator : UIActivityIndicatorView?
    var currentDateString : NSString?
    var aDayPriorDateString : NSString?
    var tableViewPassedResultsMode : Bool?
    var failedReasonWithDevices : NSMutableDictionary?
    var failedResultIds : NSArray?
    @IBOutlet weak var passedCountLabel : UILabel!
    @IBOutlet weak var failedCountlabel : UILabel!
//    @IBOutlet var segmentedControl : UISegmentedControl!
    @IBOutlet weak var machineNumberButton : UIButton!
    @IBOutlet weak var techSupportContactButton : UIButton!
    @IBOutlet weak var operatorButton : UIButton!
    var techSupport : TechSupportInfo?
    @IBOutlet weak var roundedHeaderLabel : GSRoundedCornerLabel!
    var operatorId : String?
    
    @IBOutlet weak var passCountButton : UIButton!
    @IBOutlet weak var failedCountButton : UIButton!
    @IBOutlet weak var passfailButtonContainer : UIView!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var image = UIImage(named: "Setting.png")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Done, target: self, action: #selector(DashboardViewController.openSettingPage))
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
//        self.segmentedControlHeightConstraint.constant = 50; // or whatever height you wish
        
        self.machineNumberButton.setTitle(self.stationID, forState: UIControlState.Normal)
        self.techSupportContactButton.setTitle(self.techSupport?.techSupportName, forState: UIControlState.Normal)

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
        
        self.passfailButtonContainer.layer.setBorderColorFromUIcolor(UIColor(netHex : 0xd9d9d8))
        self.passfailButtonContainer.layer.borderWidth = 1.0;
        
        self.applyAttributesTosegmentText("0", failedCount: "0")
        
        
    }
    
    
    func applyAttributesTosegmentText(passedCount : String, failedCount : String) {
        
   
        let font1 = UIFont(name: ".HelveticaNeueDeskInterface-Bold", size: 24)!
        
        let myAttributes2 = [ NSForegroundColorAttributeName: UIColor(netHex : 0x3c97d3),
                              NSFontAttributeName : font1]
        let passedCountText = passedCount+"\n";

        let myString = NSMutableAttributedString(string: passedCountText, attributes: myAttributes2 )
        
        
        let font3 = UIFont(name: ".HelveticaNeueDeskInterface-Regular", size: 18)!

        let myAttributes4 = [ NSForegroundColorAttributeName: UIColor.blackColor(),
                              NSFontAttributeName : font3]
        
        let attrString = NSAttributedString(string: " Passed", attributes: myAttributes4)
        myString.appendAttributedString(attrString)
        
        self.passCountButton.setAttributedTitle(myString, forState: UIControlState.Normal)
        self.passCountButton.titleLabel?.numberOfLines = 0;
        self.passCountButton.titleLabel?.textAlignment = NSTextAlignment.Center
        
        
        let font2 = UIFont(name: ".HelveticaNeueDeskInterface-Bold", size: 24)!
        
        let myAttributes3 = [ NSForegroundColorAttributeName: UIColor(netHex: 0xed1c24),
                              NSFontAttributeName : font2]
        let failedCount = failedCount+"\n";
        let myString1 = NSMutableAttributedString(string: failedCount, attributes: myAttributes3 )
        
        
        let attrString1 = NSAttributedString(string: " failed", attributes: myAttributes4)
        myString1.appendAttributedString(attrString1)
        
        self.failedCountButton.setAttributedTitle(myString1, forState: UIControlState.Normal)
        self.failedCountButton.titleLabel?.numberOfLines = 0;
        self.failedCountButton.titleLabel?.textAlignment = NSTextAlignment.Center

    }
    
    func openSettingPage() {
        let myStoryBoard:UIStoryboard = UIStoryboard(name:"Setting", bundle:nil)
        
        let settingViewController = myStoryBoard.instantiateViewControllerWithIdentifier("SettingVC") as! SettingViewController
        
        self.navigationController?.pushViewController(settingViewController, animated: true)
       
    }

    func parseResults(resultString : String) {
        
        self.passedResults = NSMutableArray();
        self.failedResults = NSMutableArray();
        
        var username : String?

        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let decryptedString = resultString.aesDecryptWithoutPaddingWithStaticIV("uY7Gm3EPID8y3cHeJQtZyUS5xKHlVZSu", iv: "");
            let set = NSCharacterSet(charactersInString: "\\,.?,\\x00..\\x1F, \t.,\0")
            let result = decryptedString.stringByTrimmingCharactersInSet(set)
            
            let obj:AnyObject? = try! NSJSONSerialization.JSONObjectWithData(result.dataUsingEncoding(NSUTF8StringEncoding)!, options:[])
            if let eraseResults = obj as? NSDictionary {
                
                if eraseResults.valueForKey("error") != nil{
                    dispatch_async(dispatch_get_main_queue(), {
                        
                       self.machineNumberButton.enabled = false
                        self.operatorButton.enabled = false
                        self.passCountButton.enabled = false
                        self.failedCountButton.enabled = false
                        
                        self.showAlert("Invalid Serial", message: "Please provide correct QR code")
                            GSActivityIndicatorView.hideActivity()
                    })
                    return
                }
                
                self.fethedEraseResults = NSMutableArray()
                
                let eraseInfoObjects = eraseResults.valueForKey("data") as! NSArray;
                
                if eraseInfoObjects.count > 0 {
                    let failedIds = NSMutableArray()
                    
                    for eraseInfo in eraseInfoObjects {
                        let anEraseInfo = eraseInfo as! NSDictionary
                        let eraseDetail = TestResultModel()
                        eraseDetail.eraseId = anEraseInfo.valueForKey("id") as? String;
                        
                        eraseDetail.status = anEraseInfo.valueForKey("status") as? String;
                        
                        eraseDetail.serialNumber = anEraseInfo.valueForKey("sn") as? String;
                        
                        eraseDetail.productType = anEraseInfo.valueForKey("product") as? String;
                        
                        eraseDetail.imeiID = anEraseInfo.valueForKey("imei") as? String;
                        
                        username = anEraseInfo.valueForKey("user") as? String;
                        
                        if let eraseStatus = eraseDetail.status {
                            
                            if eraseStatus == "0"{
                                self.passedResults!.addObject(eraseDetail)
                                
                            }else if eraseStatus == "1" {
                                self.failedResults!.addObject(eraseDetail)
                                failedIds.addObject(eraseDetail.eraseId!)
                            }
                        }
                        self.fethedEraseResults!.addObject(eraseDetail)
                    }
                    self.failedResultIds = failedIds
                } else {
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {

                    
                    let passedCount = self.passedResults?.count
                    let failedCount = self.failedResults?.count
                    
                    self.applyAttributesTosegmentText(String(passedCount!),failedCount: String(failedCount!))
//                    
                    self.operatorButton.setTitle(username!, forState: UIControlState.Normal)
                    self.operatorId = username
                    
                    GSActivityIndicatorView.hideActivity()
                })
                
            }
        }
    }
    
    @IBAction func showTechSupportInfo(sender : UIButton){
        
        
        self.performSegueWithIdentifier("TechSupportView", sender: sender)
        
    }
 
    
    @IBAction func showMachineInfo(sender : UIButton){
        
        self.performSegueWithIdentifier("MachineInfo", sender: sender)
        
    }
    @IBAction func showOperatorInfo(sender : UIButton){
        
        self.performSegueWithIdentifier("OperatorInfo", sender: sender)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TechSupportView"{
            let techsupportInfo = segue.destinationViewController as! TechSupportInfoViewController
            techsupportInfo.techSupport = self.techSupport
            
        }else if segue.identifier == "FailedTestDashboard" {
            let destinationVC = segue.destinationViewController as! FailedTestDashboardViewController
            destinationVC.failedTestIds = self.failedResultIds
            destinationVC.stationID = self.stationID
            destinationVC.failedResultsDeviceInfo = self.failedResults
        }else if segue.identifier == "DeviceInfo"{
            
            let destinationVc = segue.destinationViewController as! TestDeviceInfoViewController
            destinationVc.stationId = self.stationID
            destinationVc.testedDevices = self.passedResults
            destinationVc.showingResultsForPassed = true
        }else if segue.identifier == "MachineInfo"{
            
            let destinationVc = segue.destinationViewController as! MachineInfoViewController
            destinationVc.stationID = self.stationID
        }else if segue.identifier == "OperatorInfo"{
            let destinationVc = segue.destinationViewController as! OperatorInfoViewController
            destinationVc.operatorId = self.operatorId
        }
    }
    
    @IBAction func passedResultClicked(sender : UIButton){
        self.performSegueWithIdentifier("DeviceInfo", sender: sender)
        //            self.passedCountLabel.textColor = UIColor(netHex: 0x3c97d3)
    }
    
    @IBAction func failedResultClicked(sender : UIButton){
        
        self.performSegueWithIdentifier("FailedTestDashboard", sender: sender)
        //            self.failedCountlabel.textColor = UIColor(netHex: 0xed1c24)
        
    }
    
    func showAlert(title : NSString, message : NSString) {
        let alertController = UIAlertController(title: title as String, message:message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
