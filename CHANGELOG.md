#  SwiftOSC Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0]
### Change
- Removed ysocket and replaced with Swift Network Framework.
- Remove playground. Playground support for SwiftOSC was extremely buggy.
- Removed OSCTest app for iOS and OSCMonitor for macOS and replaced with new OSCClientTest and OSCServerTest apps. 

### Added
- Client and server classes are now bidirectional. After initial connection is established both client and server can send and receive.
- Client and server recognize timetags and send the messages to the delegate after the requested time.
- More validation on incoming data. Server would previously crash if certain invalid data was received.

### Fixed

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
 
