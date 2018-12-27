//
//  OSCAddress.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Foundation

public struct OSCAddress {
    
    //MARK: Properties
    public var string: String {
        didSet {
            if !valid(self.string) {
                self.string = oldValue
            }
        }
    }
    
    //MARK: initializers
    public init() {
        self.string = "/"
    }
    public init(_ address: String) {
        self.string = "/"
        if valid(address) {
            self.string = address
        }
    }
    
    //MARK: methods
    func valid(_ address: String) ->Bool {
        //invalid characters: space * , ? [ ] { } OR two or more / in a row AND must start with / AND no empty strings
        if address.range(of: "[\\s\\*,?\\[\\]\\{\\}]|/{2,}|^[^/]|^$", options: .regularExpression) != nil {
        
            //returns false if there are any matches
            NSLog("\"\(self.string)\" is an invalid address. Invalid characters include: space * , ? [ ] { }. No more than two consecutive \"/\". Address must start with /. No empty strings")
            
            return false
        } else {
            return true
        }
    }
}
