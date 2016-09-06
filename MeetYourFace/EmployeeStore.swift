//
//  EmployeeStore.swift
//  MeetYourFace
//
//  Created by liusy182 on 6/9/16.
//  Copyright © 2016 liusy182. All rights reserved.
//

import Foundation
import SwiftyJSON

class EmployeeStore {
    private var employees = [Employee]()
    
    init(){
        guard let path : String = NSBundle.mainBundle().pathForResource("employee", ofType: "json") else {
            return
        }
        guard let data = NSData(contentsOfFile: path) else {
            return
        }
        let json = JSON(data: data)
        
        //If json is .Dictionary
        for (key, subJson):(String, JSON) in json {
            //Do something you want
            employees.append(Employee(
                id: key,
                image: subJson["image"].stringValue,
                name: subJson["name"].stringValue,
                email: subJson["email"].stringValue,
                schedule: subJson["schedule"].arrayValue.map { $0.string!}
            ))
        }

    }
    
    func getEmployees() -> [Employee] {
        return employees
    }
    
    func getEmployee(id: String) -> Employee? {
        for employee in employees {
            if employee.id == id {
                return employee
            }
        }
        return nil
    }
}

