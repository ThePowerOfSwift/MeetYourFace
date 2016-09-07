//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit
import FoldingCell

class DemoCell: FoldingCell {
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var organizorEmail: UILabel!
    @IBOutlet weak var meetingTitle: UILabel!
    @IBOutlet weak var meetingOrganizor: UILabel!
    @IBOutlet weak var meetingEndTime: UILabel!
    @IBOutlet weak var meetingStartTime: UILabel!
    @IBOutlet weak var meetingRoomImg: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var monthDay: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var accepted: UILabel!
    @IBOutlet weak var denied: UILabel!
    @IBOutlet weak var pending: UILabel!
    
    override func awakeFromNib() {
        
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        super.awakeFromNib()
    }
    
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
}
