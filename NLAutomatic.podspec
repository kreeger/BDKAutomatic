Pod::Spec.new do |s|
  s.name         = "NLAutomatic"
  s.version      = "0.1.0"
  s.summary      = "A framework for talking to the Automatic API."
  s.homepage     = "https://github.com/nelsonleduc/NLAutomatic"
  s.license      = 'MIT'
  s.author       = { "Nelson LeDuc" => "nelson.leduc@jumpspaceapps.com" }
  s.source       = { :git => "https://github.com/nelsonleduc/NLAutomatic.git", :tag => "#{s.version}" }

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc = true

  s.subspec 'Adapter' do |sub|
    sub.source_files = 'Classes/*.{h,m}'
    sub.dependency 'AFNetworking/NSURLConnection', '~> 2.0'
  end

  s.subspec 'MKPolyline' do |sub|
    sub.source_files = 'Classes/MapKit/*.{h,m}'
    sub.frameworks = 'MapKit'
  end
  
  s.subspec 'Promise' do |sub|
    sub.source_files = 'Classes/Promise/*.{h,m}'
    sub.dependency 'PromiseKit/Promise'
  end
end
