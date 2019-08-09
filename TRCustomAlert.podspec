
Pod::Spec.new do |s|
  s.name             = 'TRCustomAlert'
  s.version          = '0.2.6'
  s.summary          = ' TRCustomAlert is very goods'


  s.description      = <<-DESC
			卓朗封装的提示框
                       DESC

  s.homepage         = 'https://github.com/troila-mobile/troila-mobie-CustomAlert-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mayinwei' => '843912524@qq.com' }
  s.source           = { :git => 'https://github.com/troila-mobile/troila-mobie-CustomAlert-iOS.git', :tag => "0.2.6" }

  s.social_media_url = 'https://github.com/Mayinwei'

  #s.ios.deployment_target = '8.0'
   s.platform     = :ios, '8.0'

  s.source_files = 'TRCustomAlert/*.{h,m}'
  
   #s.resource_bundles = {
   #  'CustomAlert' => ['TRCustomAlert/CustomAlertImage.bundle/*.{png,gif}']
   #}
   s.resources = "TRCustomAlert/CustomAlertImage.bundle"

   s.public_header_files = 'TRCustomAlert/*.h'
   s.frameworks = 'UIKit'
   s.dependency  'Masonry'


end
