require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name    = "ARNKakaoNavi"
  s.version = package['version']
  s.summary = "Kakao Navigation For React Native."
  
  s.authors   = { "Suhan Moon" => "leader@trabricks.io" }
  s.homepage  = "https://github.com/Kwon-Bum-Kyu/react-native-kakaonavi#readme"
  s.license   = package['license']

  s.platform      = :ios, "11.0"
  s.framework     = 'UIKit'
  s.requires_arc  = true

  s.source        = { :git => "https://github.com/Kwon-Bum-Kyu/react-native-kakaonavi.git" }
  s.source_files  = "ios/*.{h,m,swift}"

  s.dependency "React"
  s.dependency "KakaoSDKCommon"
  s.dependency "KakaoSDKNavi"


end

  
