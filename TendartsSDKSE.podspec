#
# Be sure to run `pod lib lint TendartsSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
# This Service extension is needed in swift becouse a bug in cocoapods related having a subspec inside a Service Extendion, it might be corrected in cocoapods 1.4
#        https://github.com/CocoaPods/CocoaPods/issues/6711#issuecomment-307931559


Pod::Spec.new do |s|
  s.name             = 'TendartsSDKSE'
  s.version          = '1.0.1'
  s.summary          = '10darts, THE SMARTEST Push Notification Platform. For Service Extension use'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '10darts is an Autonomous Push Notifications tool that seamlessly engages your users while saving you the effort of learning and managing yet another CRM. This is for use only in your Service Extension as pointed in documentation'
  s.homepage         = 'https://10darts.com/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '10darts' => 'devteam@10darts.com' }
  s.source           = { :git => 'https://github.com/10darts/ios-TendartsSDK.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/10dartsSoftware'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TendartsSDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TendartsSDK' => ['TendartsSDK/Assets/*.png']
  # }

   s.public_header_files = 'TendartsSDK/Classes/**/*.h'


# s.frameworks = 'UIKit', 'UserNotifications'
  # s.dependency 'AFNetworking', '~> 2.3'


 s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) IN_APP_EXTENSION=1' }
 s.source_files = 'TendartsSDK/Classes/**/*'
 s.public_header_files = 'TendartsSDK/Classes/**/*.h'


end
