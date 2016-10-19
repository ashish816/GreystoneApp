//
//  ScanController.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 6/9/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftQRCode
import SwiftKeychainWrapper


class ScanController: UIViewController,AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var QrCodeString: UILabel!
    @IBOutlet weak var QRcodeImageView: UIImageView!
    let scanner = QRCode()
    var session : AVCaptureSession?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var device : AVCaptureDevice?
    var stationIdToSend: String?
    @IBOutlet weak var qrscannerButton : UIButton!
    @IBOutlet weak var enterNumberButton : UIButton!
    @IBOutlet weak var techSupportButton : UIButton!
    @IBOutlet weak var enterMachineTextField : UITextField!
    @IBOutlet weak var scannerView : UIView!
    @IBOutlet weak var scannerViewContainer : UIView!
    @IBOutlet weak var scannerViewHeight : NSLayoutConstraint!
    @IBOutlet weak var scannerViewWidth : NSLayoutConstraint!
    
    @IBOutlet weak var sendAlertTextBoxContainer : UIView!
    @IBOutlet weak var sendAlertBottomConstraint : NSLayoutConstraint!
    @IBOutlet weak var transparentOverlay : UIView!
    @IBOutlet weak var sendalerttextView : UITextView!
    
     var GDTalertText : String?
    
    var techSupport : TechSupportInfo?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        var image1 = UIImage(named: "Background 1.png")
        image1 = image1?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.view.backgroundColor = UIColor(patternImage: image1!)
        
        let colorbg = UIColor(netHex :0xF8F9FA)
        self.qrscannerButton.layer.borderColor = colorbg.CGColor
        
        let colorbg1 = UIColor(netHex :0x3C97D3)
        self.techSupportButton.layer.borderColor = colorbg1.CGColor
        
        let textFieldBoredr = UIColor(netHex : 0xd9d9d8)
        self.enterMachineTextField.layer.borderColor = textFieldBoredr.CGColor
        
        var image = UIImage(named: "Setting.png")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Done, target: self, action: #selector(DashboardViewController.openSettingPage))
        
        
        for tabBarItem in (self.tabBarController?.tabBar.items!)!
        {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        }
                
    }
    
    override func viewWillAppear(animated: Bool) {
        self.scannerView.hidden = true
    }
    
  
    @IBAction func cancelScanning(sender: AnyObject) {
        
        self.scannerView.hidden = true;
    }
    
    

    @IBAction func readQRCode(sender: AnyObject) {
        
        self.captureQRCode();

    }
    
    @IBAction func generateQRCode(sender: AnyObject) {
        
        let stringQR = "141002030";
        self.QRcodeImageView.image = QRCode.generateImage(stringQR, avatarImage: UIImage(named: "avatar"), avatarScale: 0.3);
        
    }
    
    func captureQRCode() {
        
        self.view.bringSubviewToFront(self.scannerView)
        self.scannerView.hidden = false;
        
        let containerWidth = self.scannerView.frame.size.width

        self.scannerViewWidth.constant = containerWidth / 1.5;
        self.scannerViewHeight.constant = containerWidth/1.5;
        
        self.scannerView.layoutIfNeeded()
        self.scannerViewContainer.layoutIfNeeded()
        
        self.session = AVCaptureSession()
        self.device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        let input = try! AVCaptureDeviceInput(device: device) as AVCaptureDeviceInput
        session!.addInput(input)
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session!.addOutput(output)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
         self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
        let bounds = self.scannerViewContainer.layer.bounds
        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer!.bounds = bounds
        previewLayer!.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        
        self.scannerViewContainer.layer.addSublayer(previewLayer!)
        session!.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for item in metadataObjects {
            if let metadataObject = item as? AVMetadataMachineReadableCodeObject {
                if metadataObject.type == AVMetadataObjectTypeQRCode {
                    print("QR Code: \(metadataObject.stringValue)")
                    //self.QrCodeString.text = metadataObject.stringValue;
                    self.stationIdToSend = metadataObject.stringValue
                    
                    
                }
            }
        }
        NSUserDefaults.standardUserDefaults().setObject(self.stationIdToSend, forKey: "machineID")
        
        self.performSegueWithIdentifier("DashboardSegue", sender: nil)
        self.session!.stopRunning()
        self.previewLayer?.removeFromSuperlayer()
        self.session = nil;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let machineNumber = textField.text
        self.stationIdToSend = machineNumber
        NSUserDefaults.standardUserDefaults().setObject(self.stationIdToSend, forKey: "machineID")
        
        if textField.text == "" {
            
        } else {
            self.performSegueWithIdentifier("DashboardSegue", sender: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StationSegue" {
            let destinationStationVC = segue.destinationViewController as! ViewController;
            destinationStationVC.stationID = self.stationIdToSend
            
        } else if segue.identifier == "DashboardSegue" {
            let destinationStationVC = segue.destinationViewController as! DashboardViewController;
            destinationStationVC.stationID = self.stationIdToSend
            destinationStationVC.techSupport = self.techSupport
        } else if segue.identifier == "TechSupportView"{
            let techsupportInfo = segue.destinationViewController as! TechSupportInfoViewController
            techsupportInfo.techSupport = self.techSupport
        }
    }
  
    @IBAction func clickedMachineNumber(sender: AnyObject) {
        self.performSegueWithIdentifier("DashboardSegue", sender: sender as! UIButton)
    }
    
    @IBAction func sendGdtAlert(sender: AnyObject) {
        self.sendAlertTextBoxContainer.hidden = false;
        self.transparentOverlay.hidden = false;
        
        UIView.animateWithDuration(0.25) {
            self.sendAlertBottomConstraint.constant = self.view.frame.size.height/2;
            self.sendAlertTextBoxContainer.layoutIfNeeded()
        }
        
    }
    
    func openSettingPage() {
        let myStoryBoard:UIStoryboard = UIStoryboard(name:"Setting", bundle:nil)
        
        let settingViewController = myStoryBoard.instantiateViewControllerWithIdentifier("SettingVC") as! SettingViewController
        
        self.navigationController?.pushViewController(settingViewController, animated: true)
        
    }
    
    @IBAction func showTechSupportInfo(sender : UIButton){
        self.performSegueWithIdentifier("TechSupportView", sender: sender)
        
    }
    
    @IBAction func cancelAlertTextPopover(send : UIButton) {
        
        self.sendalerttextView.text = ""
//        self.sendalerttextView.resignFirstResponder()
        self.textViewDidEndEditing(self.sendalerttextView)

        UIView.animateWithDuration(0.25, animations: {
            self.sendAlertBottomConstraint.constant = 0;
            self.sendAlertTextBoxContainer.layoutIfNeeded()
            }) { (true) in
                self.sendAlertTextBoxContainer.hidden = true;
                self.transparentOverlay.hidden = true;
        }
        
    }
    
    @IBAction func ClickedPopoverSend(send : UIButton) {
        
        self.textViewDidEndEditing(self.sendalerttextView)
        
        var machineNumber : String
        
        if let machineId = NSUserDefaults.standardUserDefaults().valueForKey("machineID") as? String {
            machineNumber = machineId
        } else {
            machineNumber = ""
        }
        
        var alertText : String = self.GDTalertText != nil ? self.GDTalertText! : ""
        
        if alertText.isEmpty {
            self.showAlert("No Message", message: "Please provide alert message.")
            return
        }
        
        let retrievedUsername: String? = KeychainWrapper.stringForKey("username")
        
        var fname : String = "", lname  : String = "", email : String = "", phone: String = ""

        if let userInfo = self.loadContact() as? UserInfo {
            
            fname = userInfo.firstName != nil ? userInfo.firstName! : ""
            lname = userInfo.lastName != nil  ? userInfo.lastName! : ""
            email = userInfo.emailAddress != nil ? userInfo.emailAddress! : ""
            phone = userInfo.phoneNumber != nil ? userInfo.phoneNumber! : ""
            
            
            let values = ["command" : "send-email-alert", "station_serial" : machineNumber, "username" :retrievedUsername!, "content" : alertText, "firstname" : fname, "lastname" : lname, "email" : email, "phone" : phone];
            GSActivityIndicatorView.showActivity(self.view, color: UIColor.whiteColor())
            
            ServiceConnector.sendGdtAlert(values) { (response, error) in
                if let errorValue = error {
                    print("Error retrieving Result", errorValue)
                    
                }else {
                    self.parseResults(response as! String);
                }
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
            
            dispatch_async(dispatch_get_main_queue(), {
                GSActivityIndicatorView.hideActivity()
                self.cancelAlertTextPopover(UIButton(type : UIButtonType.Custom))
             
            })
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        self.GDTalertText = textView.text
        textView.resignFirstResponder()
        
    }
    
    func loadContact() -> AnyObject? {
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObjectWithFile(UserInfo.ArchiveURL.path!)
        
        if unarchivedObject == nil {
            self.showAlert("No Contact Info", message: "Please provide contact info on Setting Page.")
            return nil
        }
        
        return unarchivedObject
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return textView.text.characters.count + (text.characters.count - range.length) <= 140
    }
    
    func showAlert(title : NSString, message : NSString) {
        let alertController = UIAlertController(title: title as String, message:message as String, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    }
    
