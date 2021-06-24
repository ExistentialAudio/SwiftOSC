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
            // first turn integer into a byte array
            let bytes: [UInt8] = withUnsafeBytes(of: Int32(self).bigEndian, Array.init)
            return Data(bytes)
        }
    }
    init(_ data: Data) {
        // recover float from a byte array
        let result = data.withUnsafeBytes {
            $0.load(fromByteOffset: 0, as: Int32.self).bigEndian
        }
        self = Int(result)
    }
}
