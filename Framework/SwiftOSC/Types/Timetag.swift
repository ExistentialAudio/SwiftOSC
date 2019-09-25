//
//  OSCTypes.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Foundation

public typealias Timetag = UInt64

extension Timetag: OSCType {
    
    public var tag: String {
        get {
            return "t"
        }
    }
    public var data: Data {
        get {
            var int = self.bigEndian
            let buffer = UnsafeBufferPointer(start: &int, count: 1)
            return Data(buffer: buffer)
        }
    }
    public var secondsSince1900: Double {
        get {
            return Double(self / 0x1_0000_0000)
        }
    }
    public var secondsSinceNow: Double {
        get {
            if self > 0 {
                return Double((self - Date().oscTimetag) / 0x1_0000_0000)
            } else {
                return 0.0
            }
        }
    }
    public init(secondsSinceNow seconds: Double){
        self = Date().oscTimetag
        self += UInt64(seconds * 0x1_0000_0000)
    }
    public init(secondsSince1900 seconds: Double){
        self = UInt64(seconds * 0x1_0000_0000)
    }
    init(_ data: Data){
        var int = UInt64()
        let buffer = UnsafeMutableBufferPointer(start: &int, count: 1)
        _ = data.copyBytes(to: buffer)
        
        self =  int.byteSwapped
    }
}
