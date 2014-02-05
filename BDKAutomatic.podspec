Pod::Spec.new do |s|
  s.name         = "BDKAutomatic"
  s.version      = "0.1.0"
  s.summary      = "A framework for talking to the Automatic API."
  s.homepage     = "https://github.com/kreeger/BDKAutomatic"
  s.license      = 'MIT'
  s.author       = { "Ben Kreeger" => "ben@kree.gr" }
  s.source       = { :git => "https://github.com/kreeger/BDKAutomatic.git", :tag => "v#{s.version}" }

  # s.platform     = :ios, '5.0'
  s.ios.deployment_target = '7.0'
  # s.osx.deployment_target = '10.8'
  s.requires_arc = true

  s.source_files = 'Classes/**/*.{h,m}'
  s.resources = 'Assets'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  s.dependency 'AFNetworking/Serialization', '~> 2.0.0'
  s.dependency 'AFNetworking/NSURLSession', '~> 2.0.0'
end
