#
# Be sure to run `pod lib lint SVWebService.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SVWebService"
  s.version          = "0.1.0"
  s.summary          = "A minimalistic framework built on top of JSONModel and AFNetworking that makes REST networking dead simple."
  s.description      = "SVWebService makes REST networking simple. You create services which will serve as interfaces to the API. These will return type-safe JSONModel objects. SVProvider offers convenience methods for GET, PUT, POST, and DELETE requests."
  s.homepage         = "https://github.com/Skyvive/SVWebService"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Brad Hilton" => "brad.hilton.nw@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/SVWebService.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'SVWebService' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'SystemConfiguration', 'MobielCoreServices'
  s.dependency 'JSONModel', '~> 1.0.1'
  s.dependency 'AFNetworking', '~> 1.3.0'

end
