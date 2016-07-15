//
//  OSCTypes.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Foundation

extension Int: OSCType {
    public var tag: String {
        get {
            return "i"
        }
    }
    public var data: Data {
        get {
            var int = Int32(self).bigEndian
            let buffer = UnsafeBufferPointer(start: &int, count: 1)
            let data = Data(buffer: buffer)
            return data
        }
    }
    init(_ data: Data) {
        var int = Int32()
        let buffer = UnsafeMutableBufferPointer(start: &int, count: 1)
        _ = data.copyBytes(to: buffer)
        
        self =  Int(int.byteSwapped)
    }
}
