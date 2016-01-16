Pod::Spec.new do |s|
	s.name = "IQURLConnection"
	s.version = "1.0.0"
	s.summary = "A replacement of sendAsynchronousRequest of NSURLConnection with ResponseBlock, ProgressBlock & CompletionBlock."
	s.homepage = "https://github.com/hackiftekhar/IQURLConnection"
	s.screenshots = "https://raw.githubusercontent.com/hackiftekhar/IQURLConnection/master/Screenshot/IQURLConnectionScreenshot.jpg"
	s.license = 'MIT'
	s.author = { "Iftekhar Qurashi" => "hack.iftekhar@gmail.com" }
	s.platform = :ios, '6.0'
	s.source = { :git => "https://github.com/hackiftekhar/IQURLConnection.git", :tag => "v1.0.0" }
	s.source_files = 'Classes', 'IQURLConnection/*.{h,m}'
	s.requires_arc = true
end
