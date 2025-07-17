#
# Be sure to run `pod lib lint McccNotify.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'McccNotify'
  s.version          = '0.1.0'
  s.summary          = 'A short description of McccNotify.'

  
                       
  s.homepage         = 'https://github.com/Mccc/McccNotify'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mccc' => 'iAmMccc' }
  s.source           = { :git => 'https://github.com/Mccc/McccNotify.git', :tag => s.version.to_s }

  s.swift_version    = '5.0'
  
  s.ios.deployment_target = '15.0'
  
  
  s.subspec 'Log' do |ss|
    ss.source_files = "McccNotify/Classes/Log/**/*"
  end

  s.subspec 'Service' do |ss|
    ss.source_files = "McccNotify/Classes/Service/**/*"
    ss.dependency 'McccNotify/Log'
  end
  
  
  s.subspec 'Send' do |ss|
    ss.source_files = "McccNotify/Classes/Send/**/*"
    ss.dependency 'McccNotify/Log'
  end
  
end
