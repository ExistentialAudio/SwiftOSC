//
//  Int.swift
//  SwiftOSC
//
//  Created by Devin Roth on 2018-12-28.
//  Copyright © 2019 Devin Roth. All rights reserved.
//

import Foundation

extension Int32 {
    func toData() -> Data {
        var int = self.bigEndian
        let buffer = UnsafeBufferPointer(start: &int, count: 1)
        return Data(buffer: buffer)
    }
}

extension UInt32 {
    func toData() -> Data {
        var int = self.bigEndian
        let buffer = UnsafeBufferPointer(start: &int, count: 1)
        return Data(buffer: buffer)
    }
}

extension Int64 {
    func toData() -> Data {
        var int = self.bigEndian
        let buffer = UnsafeBufferPointer(start: &int, count: 1)
        return Data(buffer: buffer)
    }
}
