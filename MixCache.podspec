Pod::Spec.new do |s|
  s.name         = "MixCache"
  s.version      = "0.2.0"
  s.summary      = "easy cache object"
  s.description  = "easy cache object for iOS in swift"
  s.homepage     = "https://github.com/longminxiang/MixCache"
  s.license      = "MIT"
  s.author       = { "Eric Lung" => "longminxiang@gmail.com" }
  s.source       = { :git => "https://github.com/longminxiang/MixCache.git", :tag => "v" + s.version.to_s }
  s.requires_arc = true
  s.platform     = :ios, '8.0'
  s.source_files = "MixCache/MixCache/*.{swift}"
end
