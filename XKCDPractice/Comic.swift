//
//  View.swift
//  XKCDPractice
//
//  Created by AmamiYou on 2018/06/11.
//  Copyright © 2018年 AmamiYou. All rights reserved.
//

import Foundation

struct Comic {
    var num:Int?
    var img:String?
    var title:String?
    var alt:String?
    var date:Date?
    
    private var year:String?
    private var month:String?
    private var day:String?
    
    init(_ dict:[String: AnyObject]) {
        self.num = dict["num"] as? Int
        self.img = dict["img"] as? String
        self.title = dict["title"] as? String
        self.alt = dict["alt"] as? String
        self.date = dict["date"] as? Date
        
        guard let year = self.year, let month = self.month, let day = self.day else {
            //NSLog("Could not sub %@ / %@ / %@", self.year! as NSString, self.month! as NSString, self.day! as NSString)
            return
        }
        
        var components = DateComponents()
        components.calendar = Calendar.current
        components.year = Int(year)
        components.month = Int(month)
        components.day = Int(day)
        self.date = components.date
    }
}
