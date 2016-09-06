//
//  InstantMeetViewController.swift
//  MeetYourFace
//
//  Created by liusy182 on 6/9/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import UIKit

import CoreImage
import AVFoundation
import Cartography


class InstantScanViewController: UIViewController {
    
    var label = UILabel()
    var button = UIButton()
    var isFirstLoad = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if(isFirstLoad) {
            isFirstLoad = false
            let vc = ScanViewController()
            presentViewController(vc, animated: true, completion: nil)
        }
        super.viewDidAppear(animated)
    }
    
    private func setup() {
        label.text = "Raffles Place is available! Do you want to have it booked for the next hour?"
        
        label.frame = CGRectMake(0, 0, 300, 50)
        label.textAlignment = NSTextAlignment.Center
        label.center = CGPoint(x: view.center.x,
                                y: view.center.y / 1.5)
        label.textColor = UIColor.blackColor()
        label.numberOfLines = 0
        
        view.addSubview(label)
        
        button.setTitle("Book", forState: .Normal)
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.frame = CGRect(
            origin: CGPoint(x: 0, y: 0),
            size: CGSize(width: 200, height: 50))
        
        button.center = CGPoint(x: view.center.x,
                                y: view.center.y * 4 / 3)
        button.backgroundColor = UIColor(
            red: CGFloat(0x4c / 255.0),
            green: CGFloat(0xd9 / 255.0),
            blue: CGFloat(0x64 / 255.0),
            alpha: CGFloat(1.0)
        )
        button.addTarget(
            self,
            action: #selector(InstantScanViewController.meetingConfirmed(_:)),
            forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
    }
    
    func meetingConfirmed(sender: UIButton) {
        let alertController = UIAlertController(title: "Booking Successful", message: "You have sucessfully booked Raffles Place for 1 hour", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK",
                                     style: UIAlertActionStyle.Default) {
                                        UIAlertAction in self.isFirstLoad = true
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}

