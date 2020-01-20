#  SwiftOSC Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.3.1] - Unreleased
### Added
- Support for watchOS and tvOS


## [1.3.1] - 2020-01-19
### Changed
- Changed OSCClient and OSCServer from public to open allowing for mocks
- OSCServerDelegate protocol conforms to class
- Changed var to let in a number of places.
- 

## [1.3.0] - 2019-09-24
### Added
- Timetags in OSCBundles are now delivered at the correct time. 

## [1.2.8] - 2019-09-19
### Changed
- Various bug fixes
- Better handeling of optionals
- Changed Data()->toString to return optional

## [1.2.7] - 2019-09-18
### Added
- OSCTest saves IP Address and Port to UserDefaults

### Changed
- Wrapped strings in autoreleasepool.

## [1.2.4] - 2019-04-02
### Added
- Enable UDP Client Broadcast

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
