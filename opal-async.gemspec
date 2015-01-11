# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opal/async/version'

Gem::Specification.new do |gem|
  gem.name          = 'opal-async'
  gem.version       = Opal::Async::VERSION
  gem.authors       = ['Ravenstine']
  gem.email         = ['benjamin@pixelstreetinc.com']
  gem.description   = "Provides non-blocking tasks and enumerators for Opal."
  gem.summary       = "Provides non-blocking tasks and enumerators for Opal."
  gem.homepage      = 'http://github.com/ravenstine/opal-async'
  gem.rdoc_options << '--main' << 'README' <<
                      '--line-numbers' <<
                      '--include' << 'opal'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'opal', ['>= 0.5.0', '< 1.0.0']
  gem.add_development_dependency 'rake'
end
