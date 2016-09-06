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
        if let path : String = NSBundle.mainBundle().pathForResource("employee", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                let json = JSON(data: data)
                
                for (key,subJson):(String, JSON) in json {
                    let offset = Int(key)! - 1
                    let name = subJson["name"].stringValue
                    var imageName = subJson["image"].stringValue
                    let meetings = subJson["schedule"].arrayValue
                    
                    let testLabel = UILabel()
                    testLabel.frame = CGRect(x: 0, y: offset * 225 + 202, width: 200, height: 21)
                    testLabel.text = name + " has " + String(meetings.count) + " meetings"
                    view.addSubview(testLabel)
                    
                    if (imageName == "") {
                        imageName = "Autodesklogo"
                    }
                    
                    let image = UIImage(named: imageName)
                    let imageView = UIImageView(image: image!)
                    imageView.frame = CGRect(x: 0, y: offset * 225, width: 200, height: 200)
                    view.addSubview(imageView)
                }
                
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
