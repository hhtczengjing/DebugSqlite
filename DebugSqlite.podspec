Pod::Spec.new do |s|
  s.name         = "DebugSqlite"
  s.version      = "0.1.1"
  s.summary      = "A useful tool to view SQLite file in Web browser during app running￼procedure."
  s.description  = <<-DESC
                    You can input your SQL query in the URI. And you can set TableName、 LIMIT、 OFFSET in navigation bar easily, too.
                    DESC
  s.homepage     = "https://github.com/hhtczengjing/DebugSqlite"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "callmewhy" => "https://github.com/callmewhy" }
  s.platform = :ios, "6.0"
  s.source = { :git => "https://github.com/hhtczengjing/DebugSqlite.git", :tag => '0.1.1'}
  s.source_files  = "DebugSqlite/**/*.{h,m}"
  s.dependency 'FMDB', '~> 2.5'
  s.dependency 'CocoaHTTPServer', '~> 2.3'
  s.dependency 'CocoaAsyncSocket', '~> 7.4.2'
  s.resource = "DebugSqlite/Web.bundle"
  s.requires_arc = true
end
