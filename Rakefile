# encoding: utf-8
require 'rubygems'
require 'bundler'
begin
  Bundler.require(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
# require 'bundler/gem_tasks'
require 'juwelier'
Juwelier::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "opal-async"
  gem.homepage = "http://github.com/AndyObtiva/opal-async"
  gem.license = "MIT"
  gem.summary = %Q{Provides non-blocking tasks and enumerators for Opal.}
  gem.description = %Q{Provides non-blocking tasks and enumerators for Opal.}
  gem.email = ['benjamin@pixelstreetinc.com', 'andy.am@gmail.com']
  gem.authors = ['Ravenstine', 'Andy Maleh']
  gem.rdoc_options << '--main' << 'README' <<
                      '--line-numbers' <<
                      '--include' << 'opal'
  gem.files = Dir['README.md', 'LICENSE.txt', 'VERSION', 'lib/**/*', 'opal/**/*']
#   gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
#   gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  # dependencies defined in Gemfile
end
Juwelier::RubygemsDotOrgTasks.new
require 'opal/rspec/rake_task'
Opal::RSpec::RakeTask.new(:default)

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['spec'].execute
end

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "opal-async #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
