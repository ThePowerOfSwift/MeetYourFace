//
//  Meeting.swift
//  MeetYourFace
//
//  Created by liusy182 on 6/9/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import Foundation

struct Meeting {
    let id: String
    let subject: String
    let room: String
    let from: String
    let to: String
    let host: String
    let monthDay: String
    let date: String
    let accepted: String
    let denied: String
    let pending: String
    let attendees: [String]
}