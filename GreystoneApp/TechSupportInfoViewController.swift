//
//  TechSupportInfoViewController.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 6/29/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

class TechSupportInfoViewController: UIViewController {
    
    var techSupport : TechSupportInfo?
    @IBOutlet weak var techSupportName : UILabel!
    @IBOutlet weak var techSupportMail : UILabel!
    @IBOutlet weak var techSupportImage : UIImageView!
    @IBOutlet weak var techSupportPhone : UILabel!
    
    @IBOutlet weak var headerLabel : UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.techSupport == nil {
            
            let parentNavigation = self.tabBarController?.viewControllers![0] as! UINavigationController
            let scanVC = parentNavigation.viewControllers[0] as! ScanController
            let techSupport = scanVC.techSupport
            
            self.techSupport = techSupport
        }
        
        let techSupportName = self.techSupport?.techSupportName
        let techSupportMail = self.techSupport?.techSupportMail
        let techSupportNumber = self.techSupport?.techSupportPhone
        
        var image = UIImage(named: "Setting.png")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Done, target: self, action: #selector(DashboardViewController.openSettingPage))
        
        
            self.techSupportName.text = techSupportName
            self.techSupportMail.text = "Email:" + techSupportMail!
            self.techSupportPhone.text = "Phone :" + techSupportNumber!
//            self.techSupportImage.image = UIImage(data:(self.techSupport?.techSupportImageData)!,scale:1.0)
        
            if let url = NSURL(string: (self.techSupport?.techSupportImageUrl)!) {
            if let data = NSData(contentsOfURL: url) {
                self.techSupportImage.image = UIImage(data: data)
            }        
        }
        
       self.applyGradient()             // Do any additional setup after loading the view.
    }
    
    func applyGradient() {
        
        self.headerLabel.setNeedsLayout()
        self.headerLabel.layoutIfNeeded()
        
        self.headerLabel.backgroundColor = UIColor .clearColor()
        self.headerLabel.frame = self.headerLabel.bounds
        
        let gradientLayer = CAGradientLayer()
        // 2
        gradientLayer.frame = self.headerLabel.frame
        
        // 3
        let color1 = UIColor(netHex : 0x7C8083).CGColor as CGColorRef
        let color2 = UIColor(netHex: 0x46494C).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2]
        
        // 4
        gradientLayer.locations = [0.0,1.0]
        
        self.headerLabel.layer.addSublayer(gradientLayer)
        
        let textlabel = UILabel()
        textlabel.text = "Contact Information"
        textlabel.textColor = UIColor.whiteColor()
        textlabel.textAlignment = NSTextAlignment.Center
        textlabel.font = UIFont(name: ".HelveticaNeueDeskInterface-Bold", size: 17)!
        
        textlabel.frame = self.headerLabel.frame
        self.headerLabel.addSubview(textlabel)

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
}
