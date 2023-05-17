
Pod::Spec.new do |s|
s.name             = 'SwiftUIHUD'
s.version          = '0.2.3'
s.summary          = 'Loading组件.'

s.description      = <<-DESC
			Loading组件
DESC

s.homepage         = 'https://github.com/jackiehu/'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'HU' => '814030966@qq.com' }
s.source           = { :git => 'https://github.com/jackiehu/HUD', :tag => s.version.to_s }

s.ios.deployment_target = "14.0"
s.swift_versions     = ['5.5','5.4','5.3','5.2','5.1','5.0']
s.requires_arc = true

s.frameworks   = "SwiftUI", "Foundation"#支持的框架

s.source_files = 'Sources/HUD/**/*'

end
