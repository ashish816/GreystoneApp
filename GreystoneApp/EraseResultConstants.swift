//
//  EraseResultConstants.swift
//  GreystoneApp
//
//  Created by Ashish Mishra on 6/15/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit

struct EraseResultConstants {
    static let testNfc = "function_NFC"
    static let testAudio    = "function_audiotest"
    static let testCallSignal = "function_callsignal"
    static let testChargerPort = "function_device_chargerport"
    static let testEraseStatus = "function_erasestatus"
    static let testFlash = "function_flash"
    static let testGPS = "function_gps"
    static let testLcdCracked = "function_lcdcracked"
    static let testWIFI = "function_wifi"
    static let testBarometer = "function_barometer"
    static let testBarometerNote = "function_barometer_note"
    static let testBattery  = "function_batterytest"
    static let testBluetooth = "function_bluetooth"
    static let testCalltest = "function_calltest"
    static let testCamera = "function_camera"
    static let testcameraButton = "function_camerabuttonstatus"
    static let testFrontCamera = "function_camerafront"
    static let testRearCamera = "function_camerarear"
    static let testCharging = "function_charge"
    static let testCarrierActive = "function_checkcarrieractive"
    static let testCheckEngrave = "function_checkengraving"
    static let testCheckImei = "function_checkimei"
    static let testCompass = "function_compass"
    static let testCosface = "function_cosface"
    static let testCosfaceA = "function_cosfaceA"
    static let testCosfaceAA = "function_cosfaceAA"
    static let testCosfaceB = "function_cosfaceB"
    static let testCosfaceC = "function_cosfaceC"
    static let testCosfaceD = "function_cosfaceD"
    static let testCosfaceEntirePhone = "function_cosfaceEntirePhone"
    static let testCosmetic = "function_cosmetic"
    static let testCosmeticDown = "function_cosmeticdown"
    static let testCosmeticFront = "function_cosmeticfront"
    static let testCosmeticGrade = "function_cosmeticgrade"
    static let testCosmeticLeft = "function_cosmeticleft"
    static let testCosmeticRear = "function_cosmeticrear"
    static let testCosmeticRight = "function_cosmeticright"
    static let testCosmeticUp = "function_cosmeticup"
    static let testCosmeticDamagedHousing = "function_damagedhousing"
    static let testDetectESN = "function_detect_esn"
    static let testDeviceDataport = "function_device_dataport"
    static let testDeviceNumber = "function_device_phone_number"
    static let testDevicePasscode = "function_device_phone_passcode"
    static let testDigitizer = "function_digitizertest"
    static let testDimming = "function_dimming"
    static let testDownButtonStatus = "function_downbuttonstatus"
    static let testheadsetjack = "function_headsetjack"
    static let testHjackandheadphone = "function_hjackandheadphone"
    static let testHomebuttonstatus = "function_homebuttonstatus"
    static let testHovering = "function_hovering"
    static let testInternalspeaker = "function_internalspeaker"
    static let testItem = "function_item"
    static let testjailbreak = "function_jaibreak"
    static let testKeypad = "function_keypad"
    static let testlcdtest = "function_lcdtest"
    static let testlightSensor = "function_lightsensor"
    static let testLitmuspaper = "function_litmuspaper"
    static let trstMotionSensor = "function_motionsensor"
    static let testmuteButtons = "function_mutebuttonstatus"
    static let testPen = "function_pen"
    static let testplayButtonstatus = "function_playbuttonstatus"
    static let testpowerFreeze = "function_power_freeze"
    static let testIntermitter = "function_power_intermitter"
    static let testPhoneOverheat = "function_power_phone_overheating"
    static let testPowerButtonStatus = "function_powerbuttonstatus"
    static let testPowerDown = "function_powerdown"
    static let testProximitysensor = "function_proximitysensor"
    static let testFunctionresult = "function_result"
    static let testSDcardDetection = "function_sdcarddetection"
    static let testSDCardTray = "function_sdcardtray"
    static let testSimcardDetection = "function_simcarddetection"
    static let testSimcardTray = "function_simcardtray"
    static let testSMSSending = "function_smsending"
    static let testSubkeybacklight = "function_subkeybacklight"
    static let testSubkeys = "function_subkeys"
    static let testtouchIdNote = "function_touchIDnote"
    static let testtouchId = "function_touchid"
    static let testTouchScreen = "function_touchscreen"
    static let testTrackingId = "function_trackingid"
    static let testUpButtonStatus = "function_upbuttonstatus"
    static let testVibration = "function_vibration"
    static let testVideo = "function_video"
    static let testVideoFront = "function_video_front"
    static let testWirelessCharger = "function_wirelesscharger"
    static let testFucntionTestType = "functiontesttype"
    
    static let testFirstFunction = "function_FirstFailed"
    static let testBatteryTest = "function_batterytest"

    static let arrayOfTests = [ testNfc ,
        testAudio    ,
        testCallSignal ,
        testEraseStatus ,
        testFlash ,
        testGPS ,
        testLcdCracked ,
        testWIFI ,
        testBarometer ,
        testBarometerNote ,
        testBluetooth ,
        testCalltest ,
        testCamera ,
        testcameraButton ,
        testFrontCamera ,
        testRearCamera ,
        testCharging ,
        testCarrierActive ,
        testCheckEngrave ,
        testCheckImei ,
        testCompass ,
        testCosface ,
        testCosfaceA ,
        testCosfaceAA ,
        testCosfaceB ,
        testCosfaceC ,
        testCosfaceD ,
        testCosfaceEntirePhone ,
        testCosmetic ,
        testCosmeticDown ,
        testCosmeticFront ,
        testCosmeticGrade ,
        testCosmeticLeft ,
        testCosmeticRear ,
        testCosmeticRight ,
        testCosmeticUp ,
        testCosmeticDamagedHousing ,
        testDetectESN ,
        testDeviceNumber ,
        testDevicePasscode ,
        testDigitizer ,
        testDimming ,
        testDownButtonStatus ,
        testheadsetjack ,
        testHjackandheadphone ,
        testHomebuttonstatus ,
        testHovering ,
        testInternalspeaker ,
        testItem ,
        testjailbreak ,
        testKeypad ,
        testlcdtest ,
        testlightSensor ,
        testLitmuspaper ,
        trstMotionSensor ,
        testmuteButtons ,
        testPen ,
        testplayButtonstatus ,
        testpowerFreeze ,
        testIntermitter ,
        testPhoneOverheat ,
        testPowerButtonStatus ,
        testPowerDown ,
        testProximitysensor ,
        testFunctionresult ,
        testSDcardDetection ,
        testSDCardTray ,
        testSimcardDetection ,
        testSimcardTray ,
        testSMSSending ,
        testSubkeybacklight ,
        testSubkeys ,
        testtouchIdNote ,
        testtouchId ,
        testTouchScreen ,
        testTrackingId ,
        testUpButtonStatus ,
        testVibration ,
        testVideo ,
        testVideoFront ,
        testWirelessCharger,
        testFucntionTestType, testFirstFunction,testBatteryTest];
    
    static let testResultValues : NSDictionary =
        ["function_FirstFailed" : "",
         "function_NFC" : "passed",
         "function_audiotest" : "Passed",
         "function_barometer" : "passed",
         "function_barometer_note" : "passed",
         "function_batterytest" : "",
         "function_bluetooth" : "passed",
         "function_callsignal" : "passed",
         "function_calltest" : "passed",
         "function_camera" : "passed",
         "function_camerabuttonstatus" : "passed",
         "function_camerafront" : "passed",
         "function_camerarear" : "passed",
         "function_charge" : "passed",
         "function_checkcarrieractive" : "NO",
         "function_checkengraving" : "NO",
         "function_checkimei" : "passed",
         "function_compass" : "passed",
         "function_cosface" : "passed",
         "function_cosfaceA" : "passed",
         "function_cosfaceAA" : "passed",
         "function_cosfaceB" : "passed",
         "function_cosfaceC" : "passed",
         "function_cosfaceD" : "passed",
         "function_cosfaceEntirePhone" : "passed",
         "function_cosmetic" : "passed",
         "function_cosmeticdown" : "passed",
         "function_cosmeticfront" : "passed",
         "function_cosmeticgrade" : "passed",
         "function_cosmeticleft" : "passed",
         "function_cosmeticrear" : "passed",
         "function_cosmeticright" : "passed",
         "function_cosmeticup" : "passed",
         "function_damagedhousing" : "passed",
         "function_detect_esn" : "passed",
         "function_device_chargerport" : "Passed",
         "function_device_dataport" : "Passed",
         "function_device_phone_number" : "NO",
         "function_device_phone_passcode" : "NO",
         "function_digitizertest" : "passed",
         "function_dimming" : "passed",
         "function_downbuttonstatus" : "YES",
         "function_erasestatus" : "passed",
         "function_flash" : "passed",
         "function_gps" : "passed",
         "function_headphone" : "passed",
         "function_headsetjack" : "passed",
         "function_hjackandheadphone" : "passed",
         "function_homebuttonstatus" : "YES",
         "function_hovering" : "passed",
         "function_internalspeaker" : "passed",
         "function_item" : "",
         "function_jaibreak" : "passed",
         "function_keypad" : "YES",
         "function_lcdcracked" : "No",
         "function_lcdtest" : "Passed",
         "function_lightsensor" : "passed",
         "function_litmuspaper" : "NO",
         "function_motionsensor" : "passed",
         "function_mutebuttonstatus" : "YES",
         "function_pen" : "passed",
         "function_playbuttonstatus" : "YES",
         "function_power_freeze" : "passed",
         "function_power_intermitter" : "passed",
         "function_power_phone_overheating" : "passed",
         "function_powerbuttonstatus" : "YES",
         "function_powerdown" : "passed",
         "function_proximitysensor" : "passed",
         "function_result" : "Error E",
         "function_sdcarddetection" : "passed",
         "function_sdcardtray" : "passed",
         "function_simcarddetection" : "passed",
         "function_simcardtray" : "passed",
         "function_smsending" : "passed",
         "function_subkeybacklight" :"passed",
         "function_subkeys" : "passed",
         "function_touchIDnote" : "passed",
         "function_touchid" : "passed",
         "function_touchscreen" : "Passed",
         "function_trackingid" : "783246223915",
         "function_upbuttonstatus" : "YES",
         "function_vibration" : "passed",
         "function_video" : "passed",
         "function_video_front" : "passed",
         "function_wifi" : "passed",
         "function_wirelesscharger" : "passed",
         "functiontesttype" : ""
    ];
    
    static let testResultParametersMapping : NSDictionary =
        ["function_FirstFailed" : "Function First Failed",
         "function_NFC" : "NFC Failure",
         "function_audiotest" : "Audio Failure",
         "function_barometer" : "Barometer Failure",
         "function_barometer_note" : "Barometer Note",
         "function_batterytest" : "Battery Test Failure",
         "function_bluetooth" : "Bluetooth Failure",
         "function_callsignal" : "Call Signal",
         "function_calltest" : " Call Test",
         "function_camera" : "Camera Failure",
         "function_camerabuttonstatus" : "Camera Button",
         "function_camerafront" : "Front Camera Front",
         "function_camerarear" : "Rear Camera",
         "function_charge" : "Charging",
         "function_checkcarrieractive" : "Carrier Active",
         "function_checkengraving" : "Check Engraving",
         "function_checkimei" : "IMEI check",
         "function_compass" : "Compass",
         "function_cosface" : "cosface",
         "function_cosfaceA" : "cosfaceA",
         "function_cosfaceAA" : "cosfaceAA",
         "function_cosfaceB" : "cosfaceB",
         "function_cosfaceC" : "cosfaceC",
         "function_cosfaceD" : "cosfaceD",
         "function_cosfaceEntirePhone" : "cosface EntirePhone",
         "function_cosmetic" : "cosmetic",
         "function_cosmeticdown" : "Cosmetic Down",
         "function_cosmeticfront" : "Cosmetic Front",
         "function_cosmeticgrade" : "Cosmetic Grade",
         "function_cosmeticleft" : "Cosmetic Left",
         "function_cosmeticrear" : "Cosmetic Rear",
         "function_cosmeticright" : "Cosmetic Right",
         "function_cosmeticup" : "Cosmetic UP",
         "function_damagedhousing" : "Damaged Housing",
         "function_detect_esn" : "ESN detected",
         "function_device_chargerport" : "ChargerPort",
         "function_device_dataport" : "Device DataPort",
         "function_device_phone_number" : "Device Phone Number",
         "function_device_phone_passcode" : "Device Phone PassCode",
         "function_digitizertest" : "Digitizer Test",
         "function_dimming" : "Dimming",
         "function_downbuttonstatus" : "Down Button ",
         "function_erasestatus" : "Erase Failure",
         "function_flash" : "Flash",
         "function_gps" : "GPS",
         "function_headphone" : "HeadPhone",
         "function_headsetjack" : "HeadSet Jack",
         "function_hjackandheadphone" : "HJack And Headphone",
         "function_homebuttonstatus" : "Home Button ",
         "function_hovering" : "Hovering",
         "function_internalspeaker" : "Internal Speaker",
         "function_item" : "Function Item",
         "function_jaibreak" : "Jailbreak",
         "function_keypad" : "Keypad ",
         "function_lcdcracked" : "LCD Cracked",
         "function_lcdtest" : "LCD Test",
         "function_lightsensor" : "Light Sensor",
         "function_litmuspaper" : "Litmus Paper",
         "function_motionsensor" : "Motion Sensor",
         "function_mutebuttonstatus" : "Mute Button ",
         "function_pen" : "Pen",
         "function_playbuttonstatus" : "Play Button",
         "function_power_freeze" : "Power Freeze",
         "function_power_intermitter" : "Power Intermitter",
         "function_power_phone_overheating" : "Phone Overheating",
         "function_powerbuttonstatus" : "Power Button",
         "function_powerdown" : "Power Down",
         "function_proximitysensor" : "Proximity Sensor",
         "function_result" : "Function Result",
         "function_sdcarddetection" : "SD Card Detection",
         "function_sdcardtray" : "SD card Tray",
         "function_simcarddetection" : "Sim Card Detection",
         "function_simcardtray" : "Sim Card Tray",
         "function_smsending" : "SMS sending",
         "function_subkeybacklight" : "Sub key backlight",
         "function_subkeys" : "Subkeys",
         "function_touchIDnote" : "Touch Id Note",
         "function_touchid" : "Touch ID",
         "function_touchscreen" : "Touch Screen",
         "function_trackingid" : "Tracking ID",
         "function_upbuttonstatus" : "Up Button",
         "function_vibration" : "Vibration",
         "function_video" : "Video",
         "function_video_front" : "Video Front",
         "function_wifi" : "WIFI",
         "function_wirelesscharger" : "Wireless Charger ",
         "functiontesttype" : "Test Type",
         "No Test Performed" : "No Test Performed"
    ];

}

