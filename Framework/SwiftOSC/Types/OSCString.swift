//
//  OSCTypes.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Foundation

extension String: OSCType {
    public var oscTag: String {
        get {
            return "s"
        }
    }
    public var oscData: Data {
        get {
            var data = self.data(using: String.Encoding.utf8)!
            
            //base 32 null terminated data
            for _ in 1...4-data.count%4 {
                var null = UInt8(0)
                data.append(&null, count: 1)
            }
            
            return data
        }
    }
    init(_ data:Data){
        if let dataString = String(data: data, encoding: String.Encoding.utf8) {
            self = dataString
            return
        }
        
        if let dataString = String(data: data, encoding: String.Encoding.windowsCP1252) {
            self = dataString
            return
        }
        
        print("SwiftOSC StringDataError: \(String(describing: data))")
        self = "<OSCStringDataError>"
            
        // self = String(data: data, encoding: String.Encoding.utf8)! // was crashing on german umlaut characters
    }
}
