Pod::Spec.new do |s|  
  s.name             = "TARouterManager"  
  s.version          = "1.0.1"  
  s.summary          = "TARouterManager"    

  s.homepage         = "https://github.com/tasama/TARouterManager"  
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"  
  s.license          = 'MIT'  
  s.author           = { "tasama" => "1442284151@qq.com" }  
  s.source           = { :git => "https://github.com/tasama/TARouterManager.git", :tag => s.version.to_s } 
  s.platform         = :ios, '8.0'
  # s.social_media_url = 'https://twitter.com/NAME'  
  
  s.ios.deployment_target = '8.0'  
  # s.osx.deployment_target = '10.7'  
  s.requires_arc = true  
  
  s.source_files = 'RouterManager/*'  
  # s.resources = 'Assets'  
  
  # s.ios.exclude_files = 'Classes/osx'  
  # s.osx.exclude_files = 'Classes/ios'  
  # s.public_header_files = 'RouterManager/TARo'  
  s.frameworks = 'Foundation', 'UIKit'  
  
end 