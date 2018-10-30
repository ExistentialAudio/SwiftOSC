//
//  OSCTypes.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Foundation

public typealias Blob = Data

extension Blob: OSCType {
    public var tag: String {
        get {
            return "b"
        }
    }
    public var data: Data {
        get {
            let length = UInt32(self.count)
            var data = Data()

            data.append(length.toData())
            
            data.append(self)
            
            //base 32
            while data.count % 4 != 0 {
                var null = UInt8(0)
                data.append(&null, count: 1)
            }
            
            return data
        }
    }
    init(_ data: Data){
        self = data
    }
}
