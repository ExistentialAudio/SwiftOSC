#
# Be sure to run `pod lib lint SwiftOSC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftOSC'
  s.version          = '0.1.0'
  s.summary          = 'SwiftOSC is an Open Sound Control client and server framework written in Swift. '

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SwiftOSC is an Open Sound Control client and server framework written in Swift. SwiftOSC impliments all the functionality of the OSC 1.0 specifications (http://opensoundcontrol.org/spec-1_0) and is also exteneded to include the features of OSC 1.1 (https://hangar.org/webnou/wp-content/uploads/2012/01/Nime09OSCfinal.pdf).
                       DESC

  s.homepage         = 'https://github.com/devinroth/SwiftOSC'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Devin Roth' => 'devin@devinrothmusic.com' }
  s.source           = { :git => 'https://github.com/devinroth/SwiftOSC.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = "Framework/iOS/iOS", "Framework/**/*.{c,h,m,swift}"
  
  # s.resource_bundles = {
  #   'SwiftOSC' => ['SwiftOSC/Assets/*.png']
  # }

  s.public_header_files = 'Framework/iOS/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
