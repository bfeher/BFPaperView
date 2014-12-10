
Pod::Spec.new do |s|
  s.name         = "BFPaperView"
  s.version      = "1.0.2"
  s.summary      = "A flat view inspired by Google Material Design's Paper theme."
  s.homepage     = "https://github.com/bfeher/BFPaperView"
  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       = { "Bence Feher" => "ben.feher@gmail.com" }
  s.source       = { :git => "https://github.com/bfeher/BFPaperView.git", :tag => "1.0.2" }
  s.platform     = :ios, '7.0'
  s.dependency   'UIColor+BFPaperColors'
 
  
  s.source_files = 'Classes/*.{h,m}'
  s.requires_arc = true

end
