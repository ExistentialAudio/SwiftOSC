Pod::Spec.new do |s|
    s.name             = 'SwiftOSC'
    s.version          = '2.0.0'
    s.summary          = 'SwiftOSC is an Open Sound Control v1.1 client and server framework written in Swift.'

    s.description      = <<-DESC
SwiftOSC is an Open Sound Control client and server framework written in Swift. SwiftOSC impliments all the functionality of the OSC 1.0 specifications (http://opensoundcontrol.org/spec-1_0) and is also exteneded to include the features of OSC 1.1 (https://hangar.org/webnou/wp-content/uploads/2012/01/Nime09OSCfinal.pdf).
                       DESC

    s.homepage         = 'https://github.com/devinroth/SwiftOSC'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Devin Roth' => 'devin@devinrothmusic.com' }
    s.source           = { :git => 'https://github.com/devinroth/SwiftOSC.git', :tag => s.version.to_s }

    s.ios.deployment_target = '12.0'
    s.ios.source_files = "Framework/iOS/iOS}" , "Framework/iOS/**/*.{c,h,m,swift}", "Framework/SwiftOSC/**/*.{c,h,m,swift}"

    s.macos.deployment_target = '10.14'
    s.macos.source_files = "Framework/macOS/macOS","Framework/macOS/**/*.{c,h,m,swift}", "Framework/SwiftOSC/**/*.{c,h,m,swift}"

    s.tvos.deployment_target = '12.0'
    s.tvos.source_files = "Framework/tvOS/tvOS","Framework/tvOS/**/*.{c,h,m,swift}", "Framework/SwiftOSC/**/*.{c,h,m,swift}"

end
