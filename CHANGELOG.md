#  SwiftOSC Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [2.1.0 Unreleased]
### Added
 - Support for watchOS
 
 ### Changed
 - Fixed OSCClient connection issue following returning from the background in iOS.

## [2.0.0]

### Change
- Removed ysocket and replaced with Swift Network Framework.
- Removed playground. Playground support for SwiftOSC was extremely buggy.
- Removed OSCTest app for iOS and replaced with new OSCTest app. 
- Renamed Blob to OSCBlob
- Renamed Timetag to OSCTimetag
- Changed OSCType internal variables to oscData and oscTag

### Added
- Support for tvOS

### Fixed
 - Server would previously crash if certain invalid data was received.  Added more validation on incoming data. 
 - Client and server recognize timetags and send the messages to the delegate after the requested time.
 
 ### Known Issues
 - OSCClient loses connection following returning from the background in IOS. 
            Workaround: Restart OSCClient after returning from the background.

## [1.2.3] - 2018-10-30
### Changed
- Updated syntax/settings to Swift 4.2/Xcode 10.0

## [1.2.0] - 2018-08-18
### Added
- Changelog
- Compile framework during build for example apps.
- Add shared schemes for Carthage compatibility [#22](https://github.com/devinroth/SwiftOSC/pull/22)
- Add init with array argument to OSCMessage.

### Chaged
- Fix string decoding. String arg comparisons now work as expected.
 
