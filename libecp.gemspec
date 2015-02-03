Gem::Specification.new do |s|
  s.name        = "cf-ruby-libecp"
  s.version     = "0.1.4"
  s.summary     = "Ruby LibECP wrapper"
  s.description = "LibECP is a C++ elliptic curve cryptography library for signing, verifying signatures and generating keys."
  s.email       = "development@coinfloor.co.uk"
  s.authors     = ["Coinfloor LTD"]
  s.homepage    = "https://github.com/coinfloor/ruby-libecp"
  s.license     = "Apache License Version 2.0"

  s.add_dependency "ffi", "~> 1.9", ">= 1.9.3"
  s.required_ruby_version = ">= 1.9.3"

  s.files         = ["lib/libecp.rb"]
  s.require_paths = ["lib"]
end
