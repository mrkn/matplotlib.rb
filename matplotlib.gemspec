# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'matplotlib/version'

Gem::Specification.new do |spec|
  spec.name          = "matplotlib"
  spec.version       = MATPLOTLIB_VERSION
  spec.authors       = ["Kenta Murata"]
  spec.email         = ["mrkn@mrkn.jp"]

  spec.summary       = %q{matplotlib wrapper for Ruby}
  spec.description   = %q{matplotlib wrapper for Ruby}
  spec.homepage      = "https://github.com/mrkn/matplotlib.rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "pycall", ">= 1.0.0"

  spec.add_development_dependency "bundler", ">= 1.17.2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
