source 'https://github.com/CocoaPods/Specs.git'

# Uncomment this line to define a global platform for your project
platform :ios, '11.0'
# Uncomment this line if you're using Swift
use_frameworks!

inhibit_all_warnings!

def all_pods

pod 'MBProgressHUD'
pod 'UserDefaultsStore'
pod 'UITextView+Placeholder'
pod 'CodableAlamofire'
pod 'DateToolsSwift'
pod 'Alamofire', "~> 4.8" 
pod 'AlamofireNetworkActivityLogger'
#pod 'Nuke'
pod 'CocoaLumberjack/Swift'
pod 'Bond', "~> 7.6"
pod 'R.swift'
end

target 'TrackerMonitor' do
  all_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        puts target.name
    end
end
