//
//  HomeViewController.swift
//  MeetYourFace
//
//  Created by liusy182 on 28/8/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import UIKit
import FoldingCell

import UIKit

class HomeViewController: UITableViewController {
    
    let employeeStore = EmployeeStore()
    let meetingStore = MeetingStore()
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 415
    
    let kRowsCount = 10
    
    var cellHeights = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCellHeightsArray()
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
    }
    
    // MARK: configure
    func createCellHeightsArray() {
        for _ in 1...kRowsCount {
            cellHeights.append(kCloseCellHeight)
        }
    }
    
    func loadMeetings(){
        
    }
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingStore.getMeetings().count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard case let cell as DemoCell = cell else {
            return
        }
        
        cell.backgroundColor = UIColor.clearColor()
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
        
        //cell.number = indexPath.row
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FoldingCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DemoCell
        
        let meeting = meetingStore.getMeetings()[indexPath.row]
        cell.startTime.text = meeting.from.componentsSeparatedByString(" ")[1]
        cell.title.text = meeting.subject
        cell.location.text = meeting.room
        cell.meetingTitle.text = meeting.subject
        cell.meetingStartTime.text = meeting.from
        cell.meetingOrganizor.text = employeeStore.getEmployee(meeting.host)?.name
        cell.organizorEmail.text = employeeStore.getEmployee(meeting.host)?.email
        cell.meetingEndTime.text = meeting.to
        cell.avatar.image = UIImage(named:(employeeStore.getEmployee(meeting.host)!.image))!
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    // MARK: Table vie delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            }, completion: nil)
        
        
    }
    
    //Mark : Actions
    
    @IBAction func InvitePeople(sender: UIButton) {
        let vc = FaceViewController()
        vc.callback = self.faceDetectionFinished
        presentViewController(vc, animated: false, completion: nil)
    }
    
    func faceDetectionFinished() {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.alert()
        }
        
        print("faceDetectionFinished")
    }
    
    func alert() {
        let alertController = UIAlertController(title: "Sucess!", message: "Meeting invitation has been sent to Mingqi Zhang", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK",
                                     style: UIAlertActionStyle.Default,
                                     handler: nil)
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
