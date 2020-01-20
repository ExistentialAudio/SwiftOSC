//
//  OSCAddressPattern.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Foundation

public struct OSCAddressPattern {
    
    //MARK: Properties
    public var string: String {
        didSet {
            if !valid(self.string) {
                NSLog("\"\(self.string)\" is an invalid address")
                self.string = oldValue
            } else {
                self.regex = makeRegex(from: self.string)
                self.regexPath = makeRegexPath(from: self.regex)
                
            }
        }
    }
    internal var regex = ""
    internal var regexPath = ""
    internal var data: Data {
        get {
            var data = self.string.data(using: String.Encoding.utf8)!
            //make sure data is base 32 null terminated
            var null:UInt8 = 0
            for _ in 1...4-data.count%4 {
                data.append(&null, count: 1)
            }
            return data
        }
    }
    
    //MARK: Initializers
    public init(){
        self.string = "/"
        self.regex = "^/$"
        self.regexPath = "^/$"
    }
    
    public init(_ addressPattern: String) {
        self.string = "/"
        self.regex = "^/$"
        self.regexPath = "^/$"
        if valid(addressPattern) {
            self.string = addressPattern
            self.regex = makeRegex(from: self.string)
            self.regexPath = makeRegexPath(from: self.regex)
        }
    }
    
    //MARK: Methods
    internal func makeRegex(from addressPattern: String) -> String {
        var addressPattern = addressPattern
        
        autoreleasepool {
        
        //escapes characters: \ + ( ) . ^ $ |
        addressPattern = addressPattern.replacingOccurrences(of: "\\", with: "\\\\")
        addressPattern = addressPattern.replacingOccurrences(of: "+", with: "\\+")
        addressPattern = addressPattern.replacingOccurrences(of: "(", with: "\\(")
        addressPattern = addressPattern.replacingOccurrences(of: ")", with: "\\)")
        addressPattern = addressPattern.replacingOccurrences(of: ".", with: "\\.")
        addressPattern = addressPattern.replacingOccurrences(of: "^", with: "\\^")
        addressPattern = addressPattern.replacingOccurrences(of: "$", with: "\\$")
        addressPattern = addressPattern.replacingOccurrences(of: "|", with: "\\|")
        
        //replace characters with regex equivalents
        addressPattern = addressPattern.replacingOccurrences(of: "*", with: "[^/]*")
        addressPattern = addressPattern.replacingOccurrences(of: "//", with: ".*/")
        addressPattern = addressPattern.replacingOccurrences(of: "?", with: "[^/]")
        addressPattern = addressPattern.replacingOccurrences(of: "[!", with: "[^")
        addressPattern = addressPattern.replacingOccurrences(of: "{", with: "(")
        addressPattern = addressPattern.replacingOccurrences(of: "}", with: ")")
        addressPattern = addressPattern.replacingOccurrences(of: ",", with: "|")
        
        addressPattern = "^" + addressPattern       //matches beginning of string
        addressPattern.append("$")                  //matches end of string
            
        }
        
        return addressPattern
    }
    
    internal func makeRegexPath(from regex: String) -> String {

        var regex = regex
        var regexContainer = "^/$|"
        
        autoreleasepool {
            
            regex = String(regex.dropLast())
            regex = String(regex.dropFirst())
            regex = String(regex.dropFirst())
            
            let components = regex.components(separatedBy: "/")
                    for x in 0 ..< components.count {
            
                        regexContainer += "^"
            
                        for y in 0 ... x {
                            regexContainer += "/" + components[y]
                        }
            
                        regexContainer += "$|"
                    }
            
                    regexContainer = String(regexContainer.dropLast())
            
        }

        return regexContainer
        
    }
    internal func valid(_ address: String) ->Bool {
        
        var isValid = true
        
        autoreleasepool {
            
            //no empty strings
            if address == "" {
                isValid = false
            } else
                
            //must start with "/"
            if address.first != "/" {
                isValid = false
            } else
            //no more than two "/" in a row
            if address.range(of: "/{3,}", options: .regularExpression) != nil {
                isValid = false
            } else
            //no spaces
            if address.range(of: "\\s", options: .regularExpression) != nil {
                isValid = false
            } else
            //[ must be closed, no invalid characters inside
            if address.range(of: "\\[(?![^\\[\\{\\},?\\*/]+\\])", options: .regularExpression) != nil {
                isValid = false
            } else {
                var open = address.components(separatedBy: "[").count
                var close = address.components(separatedBy: "]").count

                if open != close {
                    isValid = false
                } else

                //{ must be closed, no invalid characters inside
                if address.range(of: "\\{(?![^\\{\\[\\]?\\*/]+\\})", options: .regularExpression) != nil {
                    isValid = false
                } else {
                    open = address.components(separatedBy: "{").count
                    close = address.components(separatedBy: "}").count

                    if open != close {
                        isValid = false
                    } else

                    //"," only inside {}
                    if address.range(of: ",(?![^\\{\\[\\]?\\*/]+\\})", options: .regularExpression) != nil {
                        isValid = false
                    } else
                    if address.range(of: ",(?<!\\{[^\\{\\[\\]?\\*/]+)", options: .regularExpression) != nil {
                        isValid = false
                    }
                }
            }
        }
        

        //passed all the tests
        return isValid
        
    }
    
    // Returns True if the address matches the address pattern.
    public func matches(_ address: OSCAddress)->Bool{
        
        var maches = true
        
        autoreleasepool {
            if address.string.range(of: self.regex, options: .regularExpression) == nil {
                maches = false
            }
        }
        
        return maches
    }
    
    // Returns True if the address is along the path of the address pattern
    public func matches(path: OSCAddress)->Bool{
        
        var maches = true
        autoreleasepool {
            if path.string.range(of: self.regexPath, options: .regularExpression) == nil {
                maches = false
            }
        }
        
        return maches
    }
}

