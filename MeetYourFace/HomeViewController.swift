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
        cell.meetingRoom.text = meeting.room
        cell.startTime.text = meeting.from.componentsSeparatedByString(" ")[1]
        cell.meetingStartTime.text = meeting.from
        cell.meetingOrganizor.text = meeting.host
        cell.meetingEndTime.text = meeting.to
        cell.meetingTitle.text = meeting.subject
        
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
//       let tabViewController = self.navigationController?.viewControllers[0] as! TabViewController
//        tabViewController.selectedIndex = 1
        let vc = FaceViewController()
        vc.callback = self.faceDetectionFinished
        presentViewController(vc, animated: false, completion: nil)
    }
    
    func faceDetectionFinished() {
        print("faceDetectionFinished")
    }
}
