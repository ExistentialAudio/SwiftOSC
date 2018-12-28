//
//  OSCTypes.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2018 Devin Roth Music. All rights reserved.
//

import Foundation

extension Float: OSCType {
    public var oscTag: String {
        get {
            return "f"
        }
    }
    public var oscData: Data {
        get {
            var float = CFConvertFloat32HostToSwapped(Float32(self))
            let buffer = UnsafeBufferPointer(start: &float, count: 1)
            return Data(buffer: buffer)
        }
    }
    init(_ data:Data){
        var float = CFConvertFloat32HostToSwapped(Float())
        let buffer = UnsafeMutableBufferPointer(start: &float, count: 1)
        _ = data.copyBytes(to: buffer)
        self = Float(CFConvertFloat32SwappedToHost(float))
    }
}

//convert double to float for ease of access
extension Double: OSCType {
    public var oscTag: String {
        get {
            return "f"
        }
    }
    public var oscData: Data {
        get {
            var float = CFConvertFloat32HostToSwapped(Float32(self))
            let buffer = UnsafeBufferPointer(start: &float, count: 1)
            return Data(buffer: buffer)
        }
    }
}
