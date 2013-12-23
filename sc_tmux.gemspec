# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sc_tmux/version'

Gem::Specification.new do |spec|
  spec.name          = "sc_tmux"
  spec.version       = ScTmux::VERSION
  spec.authors       = ["Aaron Nichols"]
  spec.email         = ["anichols@trumped.org"]
  spec.description   = %q{Make a remote tmux play well with ssh-agent}
  spec.summary       = %q{Make a remote tmux play well with ssh-agent}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('aruba')
  spec.add_development_dependency('rake', '~> 0.9.2')
  spec.add_dependency('methadone', '~> 1.3.1')
  spec.add_development_dependency('rspec')
end
