//
//  Data.swift
//  SwiftOSC
//
//  Created by Devin Roth on 7/5/16.
//  Copyright © 2019 Devin Roth Music. All rights reserved.
//

import Foundation

extension Data {
    func toInt32() -> Int32 {
        var int = Int32()
        let buffer = UnsafeMutableBufferPointer(start: &int, count: 1)
        _ = self.copyBytes(to: buffer)
        
        return int.byteSwapped
    }
}

extension Data {
    func toString()->String{
        return String(data: self, encoding: String.Encoding.utf8)!
    }
}

extension Data {
    public func printHexString() {
        var string = ""
        for byte in self {
            let hex = String(format:"%02X", byte)
            string += hex
        }
        print(string)
    }
}
