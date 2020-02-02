//
//  OSCTypes.swift
//  SwiftOSC
//
//  Created by Devin Roth on 6/26/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Foundation

/// A protocol for all the OSC types. The types are: Blob, Bool, Float, Impluse, Int, String, Timetag
public protocol OSCType {
    var tag: String { get }
    var data: Data { get }
}
