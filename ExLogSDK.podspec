#
# Be sure to run `pod lib lint ExLogSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ExLogSDK'
  s.version          = '0.2.1'
  s.summary          = 'A short description of ExLogSDK.'

  s.homepage         = 'https://github.com/samspirit/ExLogSDK'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'samspirit' => '11873288@qq.com' }
  s.source           = { :git => 'https://github.com/samspirit/ExLogSDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'ExLogSDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ExLogSDK' => ['ExLogSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
