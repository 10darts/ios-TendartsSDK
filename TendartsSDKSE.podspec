Pod::Spec.new do |s|
  s.name             = 'TendartsSDKSE'
  s.version          = '1.2.1'
  s.summary          = '10darts, THE SMARTEST Push Notification Platform. For Service Extension use'
  s.description      = '10darts is an Autonomous Push Notifications tool that seamlessly engages your users while saving you the effort of learning and managing yet another CRM. This is for use only in your Service Extension as pointed in documentation'
  s.homepage         = 'https://10darts.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '10darts' => 'it@10darts.com' }
  s.source           = { :git => 'https://github.com/10darts/ios-TendartsSDK.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/10dartsSoftware'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TendartsSDK/Source/**/*'
  s.public_header_files = 'TendartsSDK/Source/**/*.h'

  s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) IN_APP_EXTENSION=1' }
  s.source_files = 'TendartsSDK/Source/**/*'
  s.public_header_files = 'TendartsSDK/Source/**/*.h'

end
