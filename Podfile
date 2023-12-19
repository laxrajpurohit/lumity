# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Lumity' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Lumity
pod 'SDWebImage', '~> 5.0'
  pod 'GoogleSignIn'
  pod 'IQKeyboardManagerSwift'
  pod 'KTCenterFlowLayout'
  pod 'AlamofireObjectMapper', '~> 5.2'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  pod 'Firebase/Core'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'Cosmos', '~> 23.0'
  pod "ExpandableLabel"
  pod 'NVActivityIndicatorView'
  pod 'SDWebImageLinkPlugin'
  pod 'ImageScrollView'
  pod 'PanModal'
  pod 'SwiftReorder', '~> 7.2'
#  pod 'Socket.IO-Client-Swift'
  pod 'Socket.IO-Client-Swift', '~> 15.2.0'
  pod 'NotificationBannerSwift'#, '2.5.0'
  pod 'Firebase/Crashlytics'
  # Recommended: Add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  pod 'DropDown'
  pod 'GCCountryPicker'
  pod 'Firebase/DynamicLinks'
end

target 'ShareExtension' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ShareExtension

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

