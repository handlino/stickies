# # -*- encoding: utf-8 -*-
require File.expand_path('../lib/stickies/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["xdite"]
  gem.email         = ["xdite@techbang.com.tw"]
  gem.description   = %q{ handlino-stickies for Rails 3.0+ }
  gem.summary       = %q{ handlino-stickies for Rails 3.0+ }
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "stickies"
  gem.require_paths = ["lib"]
  gem.version       = Stickies::VERSION
end
