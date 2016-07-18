Pod::Spec.new do |spec|
  spec.name = 'SHJavascriptInterface'
  spec.version = '1.02'
  spec.license = 'MIT'
  spec.homepage = 'https://github.com/7heaven/SHJavascriptInterface'
  spec.authors = { '7heaven' => 'caifangmao8@gmail.com' }
  spec.summary = 'Easy to use javascript interface for iOS'
  spec.source_files = '*.{h,m,mm}'
  spec.source = { :git => './' }
  spec.platform = :ios
  spec.public_header_files = '*.h'
  spec.frameworks = 'Foundation', 'UIKit'
end
