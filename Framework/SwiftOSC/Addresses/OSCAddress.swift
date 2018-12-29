//
//  OSCAddress.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2019 Devin Roth Music. All rights reserved.
//

import Foundation

/**
     **OSC Address Spaces and OSC Addresses**
 
     Every OSC server has a set of OSC Methods. OSC Methods are the potential destinations of OSC messages received by the OSC server and correspond to each of the points of control that the application makes available. "Invoking" an OSC method is analogous to a procedure call; it means supplying the method with arguments and causing the method's effect to take place.
 
     An OSC Server's OSC Methods are arranged in a tree strcuture called an OSC Address Space. The leaves of this tree are the OSC Methods and the branch nodes are called OSC Containers. An OSC Server's OSC Address Space can be dynamic; that is, its contents and shape can change over time.
 
     Each OSC Method and each OSC Container other than the root of the tree has a symbolic name, an ASCII string consiting of printable characters other than the following: (space) ' ' # * , / ? [ ] { }
 
     The OSC Address of an OSC Method is a symbolic name giving the full path to the OSC Method in the OSC Address Space, starting from the root of the tree. An OSC Method's OSC Address begins with the character '/' (forward slash), followed by the names of all the containers, in order, along the path from the root of the tree to the OSC Method, separated by forward slash characters, followed by the name of the OSC Method. The syntax of OSC Addresses was chosen to match the syntax of URLs.
 
     **OSC Address Examples**
 
     Suppose a particular OSC Address Space includes an OSC Method with the name "frequency". This method is contained in an OSC Container with the name "3", which is contained in another OSC container named "resonators", which is contained in the OSC container that is the root of the address space tree. The method's OSC Address is "/resonators/3/frequency".
 
     The OSC Address "/a/b/c/d/e" means that:
 
     The root of the tree contains an OSC Container with the name "a",
     that OSC Container contains an OSC Container with the name "b",
     that OSC Container contains an OSC Container with the name "c",
     that OSC Container contains an OSC Container with the name "d",
     and that OSC Container contains an OSC Method with the name "e".
 
     **OSC Address Parts Examples**
 
     There are three parts of the OSC Address "/a/b/cde": "a",
     "b", and "cde". Note that the last part is the name of the
     OSC Method and the other parts are the names of the OSC Containers that (recursively)
     contain the method.
 
     There are three parts of the OSC Address pattern "/?/b/\*c": "?",
     "b", and "\*c".
    
*/
public struct OSCAddress {
    
    //MARK: Properties
    public let string: String
    
    //MARK: Methods
    /**
        Initialize OSCAddress with an address string. If the string is an invalid OSCAddress the initializer will fail.
     */
    public init?(_ address: String) {
        
        // Check that address is valid or fail initializer
        if address.range(of: "[\\s\\*,?\\[\\]\\{\\}]|/{2,}|^[^/]|^$", options: .regularExpression) != nil {
            
            NSLog("\"\(address)\" is an invalid address. Invalid characters include: (space) ' ' * , ? [ ] { }. Address must start with '/' (forward slash). No consecutive '/' (forward slash). No empty strings")
            
            return nil
        }
        string = address
    }
}
