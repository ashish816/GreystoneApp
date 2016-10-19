//
//  TestDeviceInfoViewController.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 7/1/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class TestDeviceInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var deviceInfoTableView : UITableView!
    var faulureReason : String?
    var testedDevices : NSArray?
    var stationId : String?
    var showingResultsForPassed : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.showingResultsForPassed {
            self.title = "Device Pass"
        } else {
            self.title = "Device Fail"
        }

        // Do any additional setup after loading the view.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if testedDevices == nil {
                return 0;
                
            } else {
            return (testedDevices?.count)!
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let cellIdentifier: String = "ResultCountCardCell"
             let currentCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as! TestCountCardCell
            let passedCount = self.testedDevices!.count
            currentCell.failedCount.text = String(passedCount)
            
            if showingResultsForPassed {
                currentCell.testStatus.text = "devices passed in"
                currentCell.failedCount.textColor = UIColor(netHex: 0x3c97d3)

            } else {
                currentCell.testStatus.text = "devices failed in"

            }
            
            cell = currentCell
            
        } else {
            let cellIdentifier: String = "DeviceInfo"
            let currentCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as! StationViewCell
            currentCell.infoButton.tag = indexPath.row
            
            currentCell.infoButton.addTarget(self, action: #selector(TestDeviceInfoViewController.infoButtonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            let testResultModel = self.testedDevices![indexPath.row] as! TestResultModel
            currentCell.imeiId.text = testResultModel.imeiID
            currentCell.productlabel.text = testResultModel.productType
            currentCell.serialNumber.text = testResultModel.serialNumber
            cell = currentCell
            
            if indexPath.row == (self.testedDevices?.count)! - 1  {
                cell?.roundedCorners(15, roundingCorners: [.BottomLeft, .BottomRight])
                cell?.setNeedsDisplay()
                cell?.setNeedsLayout()
            }
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
        
    }
    
    func infoButtonClicked(sender: UIButton){
        
        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 1)
        
        self.performSegueWithIdentifier("TestResultDetail", sender: indexPath)
//        self.deviceInfoTableView.delegate?.tableView!(self.deviceInfoTableView, didSelectRowAtIndexPath: indexPath)

        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0  {
            return 150
        } else {
            return 150
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var sectionLabel : UILabel?
        if section == 0 {
             sectionLabel = GSRoundedCornerLabel()
            if  (self.faulureReason != nil) {
                sectionLabel!.text = self.faulureReason
            } else {
                sectionLabel!.text = "GDT ALL-IN-ONE"
            }
            
        } else {
            sectionLabel = GSRoundedCornerLabel()
            sectionLabel!.text = "Device Info"
        }
        sectionLabel!.textColor = UIColor.whiteColor()
        sectionLabel!.backgroundColor = UIColor(netHex : 0x7c8590)
        sectionLabel!.textAlignment = NSTextAlignment.Center
//        sectionLabel?.layoutIfNeeded()
        sectionLabel?.setNeedsLayout()
        
        let indexSet = NSIndexSet(index: section)
        
         self.deviceInfoTableView.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.None)
        
        return sectionLabel
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("TestResultDetail", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TestResultDetail" {
            let destinationVC = segue.destinationViewController as! TestDetailViewController
            let currentIndex = sender
            let  testResultModel = self.testedDevices![currentIndex!.row] as! TestResultModel
            destinationVC.stationId = self.stationId
            destinationVC.testResultId = testResultModel.eraseId
            destinationVC.testResult = testResultModel

        }
    }
    
    func openSettingPage() {
        let myStoryBoard:UIStoryboard = UIStoryboard(name:"Setting", bundle:nil)
        
        let settingViewController = myStoryBoard.instantiateViewControllerWithIdentifier("SettingVC") as! SettingViewController
        self.navigationController?.pushViewController(settingViewController, animated: true)
        
    }
}
