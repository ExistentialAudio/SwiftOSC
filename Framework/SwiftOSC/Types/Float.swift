//
//  OSCTypes.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Foundation

extension Float: OSCType {
    public var tag: String {
        get {
            return "f"
        }
    }
    public var data: Data {
        get {
            // first turn float into a byte array
            let bytes: [UInt8] = withUnsafeBytes(of: self.bitPattern.bigEndian, Array.init)
            return Data(bytes)
        }
    }
    init(_ data:Data){
        // recover float from a byte array
        let result = Float(bitPattern: UInt32(bigEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) }))
        self = result
    }
}

//convert double to float for ease of access
extension Double: OSCType {
    public var tag: String {
        get {
            return "f"
        }
    }
    public var data: Data {
        get {
            // first turn float into a byte array
            let bytes: [UInt8] = withUnsafeBytes(of: Float(self.bitPattern.bigEndian), Array.init)
            return Data(bytes)
        }
    }
}
