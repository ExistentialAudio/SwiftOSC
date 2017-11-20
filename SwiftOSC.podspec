Pod::Spec.new do |s|
  s.name             = 'SwiftOSC'
  s.version          = '1.1.1'
  s.summary          = 'SwiftOSC is an Open Sound Control client and server framework written in Swift. '

  s.description      = <<-DESC
SwiftOSC is an Open Sound Control client and server framework written in Swift. SwiftOSC impliments all the functionality of the OSC 1.0 specifications (http://opensoundcontrol.org/spec-1_0) and is also exteneded to include the features of OSC 1.1 (https://hangar.org/webnou/wp-content/uploads/2012/01/Nime09OSCfinal.pdf).
                       DESC

  s.homepage         = 'https://github.com/devinroth/SwiftOSC'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Devin Roth' => 'devin@devinrothmusic.com' }
  s.source           = { :git => 'https://github.com/devinroth/SwiftOSC.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.3'
  s.osx.deployment_target = '10.11'

  s.ios.source_files =  = "Framework/iOS/iOS", "Framework/**/*.{c,h,m,swift}"
  s.osx.source_files =  = "Framework/macOS/macOS", "Framework/**/*.{c,h,m,swift}"

  s.public_header_files = 'Framework/iOS/**/*.h'

end
