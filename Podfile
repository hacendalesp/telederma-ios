# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Telederma' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  platform :ios, '13.0'
  use_frameworks!

  # Pods for Telederma
  pod 'Alamofire', '~> 4.0'
  # pod 'Alamofire', '~> 5.1'
  pod 'AlamofireImage', '~> 3.5'
  pod 'Alamofire-SwiftyJSON'
  pod 'AlamofireObjectMapper', '~> 5.2'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'SideMenu'
  pod 'SQLite.swift', '~> 0.12.0'
  pod "SearchTextField"
  pod 'UberSignature'
  pod 'UITextView+Placeholder'
  pod 'Presentr'
  pod 'SDWebImageWebPCoder'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end