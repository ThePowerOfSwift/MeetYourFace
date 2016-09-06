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
    
    let employeeStore = EmployeeStore()
    let meetingStore = MeetingStore()
    
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
        let homeViewController = self.storyboard!.instantiateViewControllerWithIdentifier("HomeView") as! UITableViewController
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
        
        let tabViewControllers = self.viewControllers!
        guard let toIndex = tabViewControllers.indexOf(viewController) else {
            return false
        }
        
        // Our method
        animateToTab(toIndex)
        
        return true;
    }
    
    func animateToTab(toIndex: Int) {
        let tabViewControllers = viewControllers!
        let fromView = selectedViewController!.view
        let toView = tabViewControllers[toIndex].view
        let fromIndex = tabViewControllers.indexOf(selectedViewController!)
        
        guard fromIndex != toIndex else {return}
        
        // Add the toView to the tab bar view
        fromView.superview!.addSubview(toView)
        
        // Position toView off screen (to the left/right of fromView)
        let screenWidth = UIScreen.mainScreen().bounds.size.width;
        let scrollRight = toIndex > fromIndex;
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)
        
        // Disable interaction during animation
        view.userInteractionEnabled = false
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            // Slide the views by -offset
            fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y);
            toView.center   = CGPoint(x: toView.center.x - offset, y: toView.center.y);
            
            }, completion: { finished in
                
                // Remove the old view from the tabbar view.
                fromView.removeFromSuperview()
                self.selectedIndex = toIndex
                self.view.userInteractionEnabled = true
        })
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
