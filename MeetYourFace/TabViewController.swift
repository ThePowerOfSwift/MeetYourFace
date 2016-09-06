//
//  MainViewController.swift
//  MeetYourFace
//
//  Created by liusy182 on 28/8/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import UIKit
import Cartography
import LFLoginController

class TabViewController: UITabBarController, UITabBarControllerDelegate{
    let loginController = LFLoginController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginController.delegate = self
        loginController.logo = UIImage(named: "Autodesklogo")
        loginController.videoURL = NSBundle.mainBundle().URLForResource("AutodeskShow", withExtension: "mp4")!

        self.navigationController?.pushViewController(loginController, animated: true)
        setup()
        //Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setup() {
        self.view.backgroundColor = UIColor.whiteColor()
        let homeViewController = HomeViewController()
        let homeIcon = UITabBarItem(
            title: "Meetings",
            image: UIImage(named: "Meeting-50.png"),
            selectedImage: UIImage(named: "Meeting Filled-50.png"))
        homeViewController.tabBarItem = homeIcon
        
        let cameraViewController = CameraViewController()
        let cameraIcon = UITabBarItem(
            title: "Scan",
            image: UIImage(named: "Compact Camera-50.png"),
            selectedImage: UIImage(named: "Compact Camera Filled-50.png"))
        cameraViewController.tabBarItem = cameraIcon
        
        let settingsViewController = SettingsViewController()
        let settingsIcon = UITabBarItem(
            title: "Settings",
            image: UIImage(named: "Settings-50.png"),
            selectedImage: UIImage(named: "Settings Filled-50.png"))
        settingsViewController.tabBarItem = settingsIcon
        
        
        let controllers = [homeViewController,
                           cameraViewController,
                           settingsViewController]
        self.viewControllers = controllers
    }
    
    //Delegate methods
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
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

extension TabViewController: LFLoginControllerDelegate {
    
    func loginDidFinish(email: String, password: String, type: LFLoginController.SendType) {
        
        // Implement your server call here
        
        print(email)
        print(password)
        print(type)
        
        // Example
        if type == .Login && password != "1234" {
            
            loginController.wrongInfoShake()
        } else {
            
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func forgotPasswordTapped() {
        
        print("forgot password")
    }
}
