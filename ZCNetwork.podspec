#
#  Be sure to run `pod spec lint ZCNetwork.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "ZCNetwork"
  spec.version      = "0.0.7"
  spec.summary      = "a network package by AFNetworking."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC
"a network package by AFNetworking, some request method not test."
                   DESC

  spec.homepage     = "https://github.com/Fuqingshan/ZCNetwork"
  spec.license      = { :type => "MIT", :file => "LICENSE" } 
  spec.author             = { "yier" => "898310403@qq.com" }
 
  spec.platform     = :ios,"9.0"

  spec.source       = { :git => "https://github.com/Fuqingshan/ZCNetwork.git", :tag => spec.version }

  spec.source_files = "ZCNetwork/ZCNetwork/HTTPNetwork/ZCNetwork.h"
  spec.public_header_files = "ZCNetwork/ZCNetwork/HTTPNetwork/ZCNetwork.h"

  spec.subspec 'Serializer' do |ss|
  	ss.source_files = 'ZCNetwork/ZCNetwork/HTTPNetwork/Serializer/*.{h,m}'
	ss.private_header_files = 'ZCNetwork/ZCNetwork/HTTPNetwork/Serializer/*.h'
	ss.dependency 'ZCNetwork/Helper'
  end
  
  spec.subspec 'URLSession' do |ss|
  	ss.source_files = 'ZCNetwork/ZCNetwork/HTTPNetwork/URLSession/*.{h,m}'
	ss.public_header_files = 'ZCNetwork/ZCNetwork/HTTPNetwork/URLSession/{ZCHTTPSessionManager,ZCBaseAPI,ZCFileModel}.h'
        ss.dependency 'ZCNetwork/Serializer'
	ss.dependency 'ZCNetwork/Helper'
  end
  
  spec.subspec 'Socket' do |ss|
	
  end

  spec.subspec 'Helper' do |ss|
  	ss.source_files = 'ZCNetwork/ZCNetwork/HTTPNetwork/{Cookies,Helper}/*.{h,m}','ZCNetwork/ZCNetwork/HTTPNetwork/ZCNetworkDefine.h'
	ss.private_header_files = 'ZCNetwork/ZCNetwork/HTTPNetwork/{Cookies,Helper}/*.h','ZCNetwork/ZCNetwork/HTTPNetwork/ZCNetworkDefine.h'
  end

  spec.dependency "ReactiveObjC", "~> 3.1.1"
  spec.dependency "AFNetworking", "~> 3.2.1"

end
