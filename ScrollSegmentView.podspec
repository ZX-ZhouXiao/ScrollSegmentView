Pod::Spec.new do |s|

s.name         = "ScrollSegmentView"
s.version      = "0.0.1"
s.summary      = "A SegmentView with scroll-able content view."
s.homepage     = "https://github.com/ZX-ZhouXiao/ScrollSegmentView.git"
s.license          = { :type => "MIT", :file => "LICENSE" }
s.author       = { "Jo" => "nul.zhou@gmail.com" }
s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/ZX-ZhouXiao/ScrollSegmentView.git", :tag => "0.0.1" }
s.source_files = "SegmentView/*.swift"
s.framework       = "UIKit"
s.requires_arc = true

# s.frameworks = "SomeFramework", "AnotherFramework"

end

