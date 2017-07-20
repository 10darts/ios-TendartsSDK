#
# Be sure to run `pod lib lint TendartsSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TendartsSDK'
  s.version          = '0.1.1'
  s.summary          = '10 Darts, THE SMARTEST Push Notification Platform.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '10darts is an Autonomous Push Notifications tool that seamlessly engages your users while saving you the effort of learning and managing yet another CRM'
  s.homepage         = 'https://10darts.com/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jorgeonpublico' => 'jorge.onpublico@gmail.com' }
  s.source           = { :git => 'https://github.com/10darts/ios-TendartsSDK.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/10dartsSoftware'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TendartsSDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TendartsSDK' => ['TendartsSDK/Assets/*.png']
  # }

   s.public_header_files = 'TendartsSDK/Classes/**/*.h'

  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
