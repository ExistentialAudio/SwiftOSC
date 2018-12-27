//
//  OSCTypes.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Foundation

public struct OSCImpulse {
    public init(){
        
    }
}

extension OSCImpulse: OSCType {
    public var oscTag: String {
        get {
            return "I"
        }
    }
    public var oscData: Data {
        get {
            return Data()
        }
    }
}
