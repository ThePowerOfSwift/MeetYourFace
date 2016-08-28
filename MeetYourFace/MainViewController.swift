//
//  MainViewController.swift
//  MeetYourFace
//
//  Created by liusy182 on 28/8/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import UIKit
import Cartography

class MainViewController: UIViewController {

    private let tabBar = UITabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setup() {
        view.backgroundColor = UIColor.grayColor()
        //view.addSubview(tabBar)
    }
    
    private func layout() {
//        constrain(tabBar) {
//            $0.center == $0.superview!.center
//            $0.left == $0.superview!.left
//            $0.right == $0.superview!.right
//        }
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
