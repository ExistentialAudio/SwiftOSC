//
//  String.swift
//  SwiftOSC
//
//  Created by Devin Roth on 2018-12-28.
//  Copyright © 2019 Devin Roth. All rights reserved.
//

import Foundation

extension String {
    func toData()->Data{
        return self.data(using: String.Encoding.utf8)!
    }
    func toDataBase32()->Data {
        var data = self.data(using: String.Encoding.utf8)!
        var value:UInt8 = 0
        
        for _ in 1...4-data.count%4 {
            data.append(&value, count: 1)
        }
        return data
    }
    
}
extension String {
    func dataFromHexString() -> Data {
        var data = Data()
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString.withCString { strtoul($0, nil, 16) })
            data.append([num], count: 1)
        }
        
        return data
    }
    
}
extension String {
    //returns substring at the specified character index
    subscript(index: Int)->String? {
        get {
            if index > self.count - 1 || index < 0 {
                return nil
            }
            let charIndex = self.index(self.startIndex, offsetBy: index)
            let char = self[charIndex]
            
            return String(char)
        }
    }
}
