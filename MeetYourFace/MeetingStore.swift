//
//  MeetingStore.swift
//  MeetYourFace
//
//  Created by liusy182 on 6/9/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import Foundation
import SwiftyJSON

class MeetingStore {
    private var meetings = [Meeting]()
    
    init(){
        guard let path : String = NSBundle.mainBundle().pathForResource("meeting", ofType: "json") else {
            return
        }
        guard let data = NSData(contentsOfFile: path) else {
            return
        }
        let json = JSON(data: data)
        
        //If json is .Dictionary
        for (key, subJson):(String, JSON) in json {
            //Do something you want
            meetings.append(Meeting(
                id: key,
                subject: subJson["subject"].stringValue,
                room: subJson["room"].stringValue,
                from: subJson["from"].stringValue,
                to: subJson["to"].stringValue,
                host: subJson["host"].stringValue,
                monthDay: subJson["Date"].stringValue,
                date: subJson["dayofweek"].stringValue,
                accepted: subJson["accpeted"].stringValue,
                denied: subJson["denied"].stringValue,
                pending: subJson["pending"].stringValue,
                attendees: subJson["attendees"].arrayValue.map { $0.string!}
                ))
        }
    }
    
    func getMeetings() -> [Meeting] {
        return meetings.sort({ $0.id < $1.id })
    }
    
    func getMeeting(id: String) -> Meeting? {
        for meeting in meetings {
            if meeting.id == id {
                return meeting
            }
        }
        return nil
    }

}