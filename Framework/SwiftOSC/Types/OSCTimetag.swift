//
//  OSCTypes.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Foundation

public typealias OSCTimetag = UInt64

extension OSCTimetag: OSCType {
    public var oscTag: String {
        get {
            return "t"
        }
    }
    public var oscData: Data {
        get {
            var int = self.bigEndian
            let buffer = UnsafeBufferPointer(start: &int, count: 1)
            return Data(buffer: buffer)
        }
    }
    public init(currentTimeAdd seconds: Double){
        self = Timer.sharedTime.timetag
        self += UInt64(seconds * 0x1_0000_0000)
    }
    public init(seconds: Double){
        self = UInt64(seconds * 0x1_0000_0000)
    }
    init(_ data: Data){
        var int = UInt64()
        let buffer = UnsafeMutableBufferPointer(start: &int, count: 1)
        _ = data.copyBytes(to: buffer)
        
        self =  int.byteSwapped
    }
}
