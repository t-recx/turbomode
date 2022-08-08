# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'turbomode/version'

Gem::Specification.new do |spec|
  spec.name          = "turbomode"
  spec.version       = Turbomode::VERSION
  spec.authors       = ["João Bruno"]
  spec.email         = ["bruno.joao@live.com.pt"]

  spec.summary       = "ECS framework using gosu"
  spec.description   = "ECS framework using gosu"
  spec.homepage      = "https://github.com/t-recx/turbomode"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "gosu", "~> 1.1"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5", "< 5.16"
  spec.add_development_dependency "minitest-reporters", "~> 1.4"
  spec.add_development_dependency "guard", "~> 2"
  spec.add_development_dependency "guard-minitest", "~> 2"
end
