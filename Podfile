# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'





post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end





target 'QuizApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  source 'https://github.com/CocoaPods/Specs.git'
  
  pod 'EFInternetIndicator'
  pod 'PSMeter'
  pod "RSLoadingView"
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'CRRefresh'
  pod 'FSPagerView'
  pod 'SDWebImage'
  pod 'PureLayout'
  pod 'MBRadioCheckboxButton'
  pod "CollieGallery"
  pod 'Cosmos'
  pod 'XP_PDFReader'
  pod "EPSignature"
  pod 'PDFReader'

    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'CRRefresh'
    pod 'FSPagerView'
    pod 'SDWebImage'
    pod 'PureLayout'
    pod "CollieGallery"
    pod 'Cosmos'
    pod 'RadioButton'
    pod 'Toast-Swift', '~> 5.0.1'
    
    pod 'Drops', :git => 'https://github.com/omaralbeik/Drops.git', :tag => '1.7.0'
    pod 'EmptyDataSet-Swift', '~> 5.0.0'
    pod "PullToDismissTransition"
  
  pod 'HMSegmentedControl'
  pod 'MXSegmentedPager'
  pod 'AZDialogView'
  pod 'Slider2'
  pod "BSImagePicker", "~> 2.8"
  pod 'ScrollingPageControl'

  pod 'MHLoadingButton'
  pod 'PhoneNumberKit', '~> 3.3'
  pod 'SmoothPicker'
  pod 'CustomLoader'
  pod 'LIHImageSlider'
  pod "CollieGallery"
  pod 'youtube-ios-player-helper'
  
  pod 'AlertToast'
  pod 'EFInternetIndicator'

  pod 'MZTimerLabel'
  pod 'AEOTPTextField'
  
  pod 'GravitySliderFlowLayout'
  
 
  pod 'MobilliumQRCodeReader'
 
 pod "DDHTimerControl"
 
 pod 'YoutubePlayer-in-WKWebView', '~> 0.2.0'
 
 pod 'lottie-ios'
 
 pod 'JKAlertView'

 pod 'FCAlertView'
 
 
 pod 'TagTextField'
 pod 'TagsList'
 
 pod 'DropDown'
 
 pod 'Socket.IO-Client-Swift', '~> 16.0.0'
 
end


#https://github.com/kakashysen/JKAlertView
