Pod::Spec.new do |s|
  s.name         = "JAPhotoView"
  s.version      = "0.1.0"
  s.summary      = "Simple and highly customizable iOS photo list view, in Swift."
  s.homepage     = "https://github.com/williambao/JAPhotoView"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  s.author             = { "William" => "williamyeah@vip.qq.com" }
  s.social_media_url   = "http://weibo.com/hugejingui"

  s.platform     = :ios, "9.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/williambao/JAPhotoView", :tag => s.version }
  s.source_files  = "JAPhotoView/*.swift"

  s.resource  = "JAPhotoView/*.png"

  s.requires_arc = true

  # s.dependency "JSONKit", "~> 1.4"

end
