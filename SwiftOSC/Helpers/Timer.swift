//
//  Timer.swift
//  SwiftOSC
//
//  Created by Devin Roth on 7/10/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Foundation

//let sharedTimer = Timer()

class Timer {
    static let sharedTime = Timer()
    
    private var startMachTime: UInt64
    private var startNTP: UInt64
    private var numer: UInt64
    private var denom: UInt64
    
    var timetag: UInt64 {
        get {
            let time = (((mach_absolute_time() - startMachTime) * numer ) / denom )
            let seconds = time / 0x1_0000_0000
            let nano = time % 0x1_0000_0000
            var tag = startNTP + ((nano * 0x1_0000_0000) / 1_000_000_000)
            tag = tag + seconds * 0x1_0000_0000
            
            return tag
        }
    }
    
    private init() {
        //set program start time
        startMachTime = mach_absolute_time()
        
        //set numer and denom
        var s_timebase_info = mach_timebase_info_data_t()
        mach_timebase_info(&s_timebase_info)
        numer = UInt64(s_timebase_info.numer)
        denom = UInt64(s_timebase_info.denom)
        
        //set start time
        let calendar = Calendar.current
        let dateComponents = DateComponents(timeZone: TimeZone(secondsFromGMT: 0), year: 1990)
        let date = calendar.date(from: dateComponents)
        let timeInterval = Date().timeIntervalSince(date!)
        startNTP = UInt64(timeInterval * 0x1_0000_0000)
    }
}
