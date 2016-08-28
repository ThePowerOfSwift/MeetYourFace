//
//  ViewController.swift
//  MeetYourFace
//
//  Created by liusy182 on 28/8/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import UIKit
import Cartography

class LogInViewController: UIViewController {
    private let logInButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()        // Do any additional setup after loading the view, typically from a nib.
        setup()
        layout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onLogInTappged(sender: UIButton) {
        let mainViewController = MainViewController()
        presentViewController(mainViewController, animated: false, completion: nil)
    }
    
    private func setup() {
        view.backgroundColor = UIColor.grayColor()
        logInButton.setTitle("Log In", forState: .Normal)
        logInButton.frame = CGRect(
            origin: CGPoint(x: 0, y: 0),
            size: CGSize(width: 200, height: 50))
        logInButton.addTarget(
            self,
            action: #selector(LogInViewController.onLogInTappged(_:)),
            forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(logInButton)
    }
    
    private func layout() {
        constrain(logInButton) {
            $0.center == $0.superview!.center
            $0.left == $0.superview!.left
            $0.right == $0.superview!.right
        }
    }

}

