
Pod::Spec.new do |s|
  s.name             = 'CustomAlert'
  s.version          = '0.0.1'
  s.summary          = ' CustomAlert is very good'


  s.description      = <<-DESC
			卓朗封装的提示框
                       DESC

  s.homepage         = 'https://github.com/troila-mobile/troila-mobie-CustomAlert-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mayinwei' => '843912524@qq.com' }
  s.source           = { :git => 'https://github.com/troila-mobile/troila-mobie-CustomAlert-iOS.git', :tag => "0.0.3" }

  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CustomAlert/**/*'
  
   s.resource_bundles = {
     'CustomAlert' => ['CustomAlert/CustomAlertImage.bundle/*']
   }

   s.public_header_files = 'CustomAlert/**/*.h'
   s.frameworks = 'UIKit'

end
