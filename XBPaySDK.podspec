:Pod::Spec.new do |s|
    s.name         = "XBPaySDK"
    s.version      = "1.0.0"
    s.ios.deployment_target = '8.0'
    s.summary      = "支付集成SDK，一个简单的支付集成工具."
    s.homepage     = "https://github.com/chunipo/XBPay"
    s.license              = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "Simple" => "372718588@qq.com" }
    s.source       = { :git => "https://github.com/chunipo/XBPay", :tag => s.version }
    s.source_files  = "XBPaySDK/*"
    #s.resources          = "XBPaySDK/CFMobAdSDK.bundle"
    s.fra
    s.frameworks = 'Foundation', 'UIKit'
    #s.vendored_frameworks = 'CFMobAdSDK.framework'
    s.requires_arc = true
end

