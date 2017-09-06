//
//  TableData.swift
//  OSCMonitor
//
//  Created by Devin Roth on 7/16/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Foundation
import SwiftOSC


struct TableData {
    var date: Date {
        didSet {
            addDateDescription()
        }
    }
    var dateDescription = ""
    
    var message: OSCMessage {
        didSet {
            addArgumentsDescription()
        }
    }
    var argumentsDescription = ""
    
    init(_ date: Date,_ message: OSCMessage){
        self.date = date
        self.message = message
        addDateDescription()
        addArgumentsDescription()
    }
    
    mutating func addDateDescription() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month,.day,.hour, .minute, .second, .nanosecond], from: date)
        
        let year = components.year!
        let month = components.month!
        let day = components.day!
        let hour = components.hour!
        let minute = components.minute!
        let second = components.second!
        let millis = components.nanosecond! / 1_000_000
        
        self.dateDescription = "\(year)-\(month)-\(day) \(hour):\(minute):\(second)." + String(format: "%03d", millis)
    }
    
    mutating func addArgumentsDescription() {
        var description = ""
        
        for argument in self.message.arguments {
            
            if let int = argument as? Int {
                description += " Int<\(int)>"
            }
            if let float = argument as? Float {
                description += " Float<\(float)>"
            }
            if let float = argument as? Double {
                description += " Float<\(float)>"
            }
            if let string = argument as? String {
                description += " String<\(string)>"
            }
            if let blob = argument as? Blob {
                description += " Blob\(blob)"
            }
            if let bool = argument as? Bool {
                description += " <\(bool)>"
            }
            if argument == nil {
                description += " <null>"
            }
            if argument is Impulse {
                description += " <impulse>"
            }
            if let timetag = argument as? Timetag {
                description += " Timetag<\(timetag)>"
            }
        }
        self.argumentsDescription = description
    }
}
