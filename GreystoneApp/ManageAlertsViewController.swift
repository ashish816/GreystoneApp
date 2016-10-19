//
//  ManageAlertsViewController.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 7/28/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class ManageAlertsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var machineList : NSArray?
    var alertOptions : NSArray?
    @IBOutlet weak var machineAlertTableView: UITableView!
    @IBOutlet weak var roundedHeaderLabel : GSRoundedCornerLabel!
    var collapsedSections : NSMutableSet?
    override func viewDidLoad() {
        super.viewDidLoad()
        machineAlertTableView.sectionHeaderHeight = 0
        machineAlertTableView.sectionFooterHeight = 0
        
        self.machineList = ["123232323","22323456","38784378","42365533"];
        self.alertOptions = ["Audio Loopback", "Bluetooth", "Buttons", "Camera", "Digitizer"]
        self.collapsedSections = NSMutableSet()
        for (var i = 0; i < self.machineList?.count ; i += 1) {
            self.collapsedSections?.addObject(i)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (machineList?.count)!;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            let isCollapsed = self.collapsedSections?.containsObject(section)
            return  isCollapsed! == true ? 0 : (self.alertOptions?.count)! + 2
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : UITableViewCell?
        
        if indexPath.row == 0 {
            
            let currentCell = tableView.dequeueReusableCellWithIdentifier("ExtendDailyAlertCell", forIndexPath: indexPath) as? ExtendDailyAlertCell
            
            cell = currentCell
        } else if indexPath.row == 1 {
            
             let currentCell = tableView.dequeueReusableCellWithIdentifier("PassFailAlertCell", forIndexPath: indexPath) as? PassFailAlertCell
            cell = currentCell

            
        } else {
            
            
             let currentCell = tableView.dequeueReusableCellWithIdentifier("FunctionFailureAlertCell", forIndexPath: indexPath) as? FunctionFailureAlertCell
            currentCell?.failureType.text = self.alertOptions![indexPath.row - 2] as! String
            cell = currentCell
            
            if indexPath.row % 2 == 0 {
                currentCell!.backgroundColor = UIColor.whiteColor()
            }else {
                
                currentCell?.backgroundColor = UIColor(netHex : 0xefeff3)

            }
        }
        return cell!
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = ManageAlertHeader.instanceFromNib() as! ManageAlertHeader
        headerView.expandButton.addTarget(self, action: #selector(ManageAlertsViewController.sectionButtonTouchUpInside(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        if section % 2 == 0 {
            headerView.backgroundColor = UIColor.whiteColor()
        }else {
            headerView.backgroundColor = UIColor(netHex : 0xefeff3)
        }
        
        headerView.expandButton.tag = section
        headerView.machineNumber.text = "Machine #"+(self.machineList![section] as! String) as! String
        
        return headerView
    }
    
    func sectionButtonTouchUpInside(sender : GSButton) {
        
        self.machineAlertTableView.beginUpdates()
        let section = sender.tag
        
        let shouldCollapse = !(self.collapsedSections?.containsObject(section))!
        
        if shouldCollapse {
            let numberOfRows = self.machineAlertTableView.numberOfRowsInSection(section)
            let indexpaths = self.indexPathsForSection(section, withRows: numberOfRows)
            self.machineAlertTableView.deleteRowsAtIndexPaths(indexpaths as NSArray as! [NSIndexPath], withRowAnimation:UITableViewRowAnimation.Top)
            self.collapsedSections?.addObject(section)
            sender.setExpandButtonConstraint(true)
        } else {
            let numberOfRows = (self.alertOptions?.count)! + 2;
            let indexpaths = self.indexPathsForSection(section, withRows: numberOfRows) as NSArray
            self.machineAlertTableView.insertRowsAtIndexPaths(indexpaths as! [NSIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
            self.collapsedSections?.removeObject(section)
            sender.setExpandButtonConstraint(false)
        }
        self.machineAlertTableView.endUpdates()
        
    }
    
    func indexPathsForSection(section : Int , withRows rows: Int) -> NSMutableArray {
        let indexPaths = NSMutableArray()
        
        for i in 0 ..< rows {
            let indexPath = NSIndexPath(forRow: i, inSection: section )
            indexPaths.addObject(indexPath)
        }
        return indexPaths
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 100
        } else if indexPath.row == 1 {
            return 212
        } else {
            return 50
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
}
