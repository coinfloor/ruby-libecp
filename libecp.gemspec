Gem::Specification.new do |s|
  s.name        = "cf-ruby-libecp"
  s.version     = "0.2.2"
  s.summary     = "Ruby LibECP Wrapper"
  s.description = "Ruby LibECP is a wrapper around LibECP, an elliptic-curve cryptography library for producing and verifying ECDSA signatures."
  s.email       = "development@coinfloor.co.uk"
  s.authors     = ["Coinfloor LTD"]
  s.homepage    = "https://github.com/coinfloor/ruby-libecp"
  s.license     = "Apache License Version 2.0"

  s.require_paths = %w(lib)
  s.files         = `git ls-files`.split("\n") +
                    `git submodule --quiet update --init ; cd ext/libecp ; git ls-files`.split("\n").map { |f| "ext/libecp/" + f }
  s.extensions   << "configure"

  s.add_dependency "ffi",  "~> 1.9", ">= 1.9.3"

  s.required_ruby_version = ">= 1.9.3"

  s.add_development_dependency "bundler", "~> 1.13"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry"
end
