$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sms_sender_twilio/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sms_sender_twilio"
  s.version     = SmsSenderTwilio::VERSION
  s.authors     = ["Mojtaba Ghorbanalibeik", "Hossein Bukhamseen"]
  s.email       = ["mojtaba.ghorbanalibeik@gmail.com", "bukhamseen.h@gmail.com"]
  s.homepage    = ""
  s.summary     = "Send sms via api.twilio.com"
  s.description = "Send sms via api.twilio.com"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "twilio-ruby"
end
