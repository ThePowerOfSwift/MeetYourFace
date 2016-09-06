//
//  SettingsViewController.swift
//  MeetYourFace
//
//  Created by liusy182 on 29/8/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingsViewController: UIViewController {

    let testLabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        testLabel.center = CGPointMake(160, 284)
        testLabel.textAlignment = NSTextAlignment.Center
        
        if let path : String = NSBundle.mainBundle().pathForResource("meeting", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                let json = JSON(data: data)
                
                let name = json[0]["Name"].stringValue
                let meetings = json[0]["Schedule"].arrayValue
                testLabel.text = name + " has " + String(meetings.count) + " meetings"
                /*
                 for object in meetings as! [JSON] {
                 let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
                 label.center = CGPointMake(160, 284)
                 label.textAlignment = NSTextAlignment.Center
                 label.text = object["Start"].stringValue + "-" + object["End"].stringValue + " (" + object["Name"].stringValue + ")"
                 self.view.addSubview(label)
                 }
                */
            }
        }
        self.view.addSubview(testLabel)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
