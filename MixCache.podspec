Pod::Spec.new do |s|
  s.name         = "MixCache"
  s.version      = "0.7.0"
  s.summary      = "easy cache object"
  s.description  = "easy cache object for iOS in swift"
  s.homepage     = "https://blog.mixii.cn"
  s.license      = "MIT"
  s.author       = { "Eric Lung" => "longminxiang@gmail.com" }
  s.source       = { :git => "https://github.com/longminxiang/MixCache.git", :tag => "v" + s.version.to_s }
  s.requires_arc = true
  s.platform     = :ios, '9.0'
  s.source_files = "Sources/*.{swift}"
  s.swift_version = '5.0'
end
