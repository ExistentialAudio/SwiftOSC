//
//  Date.swift
//  SwiftOSC
//
//  Created by Devin Roth on 2018-12-28.
//  Copyright © 2019 Devin Roth. All rights reserved.
//

import Foundation

extension Date {
    //initilizes time from string in the format of "1990-01-01T00:00:00-00:00"
    init?(_ string: String){
        
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let date = RFC3339DateFormatter.date(from: string)
        
        if date == nil {
            return nil
        }
        self = date!
    }
}

extension Date {
    var oscTimetag: OSCTimetag {
        get {
            return OSCTimetag(Date().timeIntervalSince(Date("1900-01-01T00:00:00-00:00")!) * 0x1_0000_0000)
        }
    }
}
