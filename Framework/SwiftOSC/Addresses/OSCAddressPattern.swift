//
//  OSCAddressPattern.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2019 Devin Roth Music. All rights reserved.
//

import Foundation

    /**
    An OSC Address Pattern is an OSC-string beginning with the character '/' (forward slash).
 
     When an OSC server receives an OSC Message, it must invoke the appropriate OSC Methods in its OSC Address Space based on the OSC Message's OSC Address Pattern. This process is called dispatching the OSC Message to the OSC Methods that match its OSC Address Pattern. All the matching OSC Methods are invoked with the same argument data, namely, the OSC Arguments in the OSC Message.
 
     The parts of an OSC Address or an OSC Address Pattern are the substrings between adjacent pairs of forward slash characters and the substring after the last forward slash character.
 
     A received OSC Message must be disptched to every OSC method in the current OSC Address Space whose OSC Address matches the OSC Message's OSC Address Pattern. An OSC Address Pattern matches an OSC Address if
 
     The OSC Address and the OSC Address Pattern contain the same number of parts; and
     Each part of the OSC Address Pattern matches the corresponding part of the OSC Address.
 
     A part of an OSC Address Pattern matches a part of an OSC Address if every consecutive character in the OSC Address Pattern matches the next consecutive substring of the OSC Address and every character in the OSC Address is matched by something in the OSC Address Pattern. These are the matching rules for characters in the OSC Address Pattern:
 
     '?' in the OSC Address Pattern matches any single character
     '*' in the OSC Address Pattern matches any sequence of zero or more characters
     A string of characters in square brackets (e.g., "[string]") in the OSC Address Pattern matches any character in the string. Inside square brackets, the minus sign (-) and exclamation point (!) have special meanings:
     two characters separated by a minus sign indicate the range of characters between the given two in ASCII collating sequence. (A minus sign at the end of the string has no special meaning.)
     An exclamation point at the beginning of a bracketed string negates the sense of the list, meaning that the list matches any character not in the list. (An exclamation point anywhere besides the first character after the open bracket has no special meaning.)
     A comma-separated list of strings enclosed in curly braces (e.g., "{foo,bar}") in the OSC Address Pattern matches any of the strings in the list.
     Any other character in an OSC Address Pattern can match only the same character.
 
    Because the initializer will fail if given an incorrectly formatted address, it is important to check for nil before adding an OSCAddressPattern to an OSCMessage.
 
```
if let addressPattern = OSCAddressPattern("/test/this/pattern"){
    let message = OSCMessage(addressPattern, oscArguments)
}
```

     */
public struct OSCAddressPattern {
    
    //MARK: Properties
    public let string: String
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
    
    //MARK: Methods
    public init?(_ addressPattern: String) {
        
        // Check if addressPattern is valid. Return nil if not.
        // No empty strings
        if addressPattern == "" {
            NSLog("\"\(addressPattern)\" is an invalid address: Address is empty.")
            return nil
        }
        // Must start with "/"
        if addressPattern.first != "/" {
            NSLog("\"\(addressPattern)\" is an invalid address. Address must begin with \"/\".")
            return nil
        }
        // No more than two "/" in a row
        if addressPattern.range(of: "/{3,}", options: .regularExpression) != nil {
            NSLog("\"\(addressPattern)\" is an invalid address. Address must not contain more than two consecutive \"/\".")
            return nil
        }
        // No spaces
        if addressPattern.range(of: "\\s", options: .regularExpression) != nil {
            NSLog("\"\(addressPattern)\" is an invalid address. Address must not contain spaces.")
            return nil
        }
        // [ must be closed, no invalid characters inside
        if addressPattern.range(of: "\\[(?![^\\[\\{\\},?\\*/]+\\])", options: .regularExpression) != nil {
            NSLog("\"\(addressPattern)\" is an invalid address. [] must closed and not contain invalid characters.")
            return nil
        }
        var open = addressPattern.components(separatedBy: "[").count
        var close = addressPattern.components(separatedBy: "]").count
        
        if open != close {
            NSLog("\"\(addressPattern)\" is an invalid address. [] must be closed.")
            return nil
        }
        
        // { must be closed, no invalid characters inside
        if addressPattern.range(of: "\\{(?![^\\{\\[\\]?\\*/]+\\})", options: .regularExpression) != nil {
            NSLog("\"\(addressPattern)\" is an invalid address. {} must not contain invalid characters: \\{(?![^\\{\\[\\]?\\*/]+\\})")
            return nil
        }
        open = addressPattern.components(separatedBy: "{").count
        close = addressPattern.components(separatedBy: "}").count
        
        if open != close {
            NSLog("\"\(addressPattern)\" is an invalid address. {} must be closed.")
            return nil
        }
        
        // "," only inside {}
        if addressPattern.range(of: ",(?![^\\{\\[\\]?\\*/]+\\})", options: .regularExpression) != nil {
            NSLog("\"\(addressPattern)\" is an invalid address. Must only contain \",\" inside {}.")
            return nil
        }
        if addressPattern.range(of: ",(?<!\\{[^\\{\\[\\]?\\*/]+)", options: .regularExpression) != nil {
            NSLog("\"\(addressPattern)\" is an invalid address. Must only contain \",\" inside {}.")
            return nil
        }
        
        self.string = addressPattern
        self.regex = makeRegex(from: self.string)
        self.regexPath = makeRegexPath(from: self.regex)
    }
    
    /// Convert addressPattern to a regexPattern for address matching
    internal func makeRegex(from addressPattern: String) -> String {
        var addressPattern = addressPattern
        
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
        
        return addressPattern
    }
    
    /// Convert Regex pattern to match a portion of the address path. Used to route incoming messages.
    internal func makeRegexPath(from regex: String) -> String {
        var regex = regex
        regex = String(regex.dropLast())
        regex = String(regex.dropFirst())
        regex = String(regex.dropFirst())

        var components = regex.components(separatedBy: "/")
        var regexContainer = "^/$|"

        for x in 0 ..< components.count {

            regexContainer += "^"

            for y in 0 ... x {
                regexContainer += "/" + components[y]
            }

            regexContainer += "$|"
        }

        regexContainer = String(regexContainer.dropLast())

        return regexContainer
        
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

