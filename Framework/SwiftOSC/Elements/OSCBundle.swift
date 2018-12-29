//
//  OSCBundle.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2019 Devin Roth Music. All rights reserved.
//
import Foundation

/**
 An OSC Bundle consists of the OSC-string "#bundle" followed by an OSC Time Tag, followed by zero or more OSC Bundle Elements. The OSC-timetag is a 64-bit fixed point time tag whose semantics are described below.
 
 An OSC Bundle Element consists of its size and its contents. The size is an int32 representing the number of 8-bit bytes in the contents, and will always be a multiple of 4. The contents are either an OSC Message or an OSC Bundle.
 
 Note this recursive definition: bundle may contain bundles.
*/
public class OSCBundle: OSCElement, CustomStringConvertible {
    //MARK: Properties
    public var timetag: OSCTimetag
    public var elements:[OSCElement] = []
    public var oscData: Data {
        get {
            var data = Data()
            //add "#bundle" tag
            data.append("#bundle".toDataBase32())
            
            //add timetag
            data.append(timetag.oscData)
            
            //add elements data
            for element in elements {
                let elementData = element.oscData
                data.append(Int32(elementData.count).toData())
                data.append(element.oscData)
            }
            return data
        }
    }
    public var description: String {
        get {
            return "OSCBundle [Timetag<\(self.timetag)> Elements<\(elements.count)>]"
        }
    }
    
    //MARK: Initializers
    public init(_ timetag: OSCTimetag){
        self.timetag = timetag
    }
    
    public init (_ timetag: OSCTimetag, _ elements: OSCElement...){
        self.timetag = timetag
        self.elements = elements
    }
    public init (_ elements: OSCElement...){
        self.timetag = 1
        self.elements = elements
    }
    
    //MARK: Methods
    public func add(_ elements: OSCElement...){
        self.elements += elements
    }
}
