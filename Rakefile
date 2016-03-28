require 'rake'
require 'rdoc/task'
require 'rake/clean'
require 'rspec/core/rake_task'
require 'jeweler'

desc 'Default: run unit tests.'
task :default => :test

Jeweler::Tasks.new do |jewel|
  jewel.name            = 'validates_airline_addendum'
  jewel.summary         = "Library for validating airline data."
  jewel.email           = ['greentlalok@gmail.com']
  jewel.homepage        = 'https://github.com/seongreen/validates_airline_addendum/tree/master'
  jewel.description     = 'Library for validating airline data.'
  jewel.authors         = ["Andrei Novikau"]
  jewel.files           = FileList["lib/**/*.rb", "*.rb", "MIT-LICENCE", "README.markdown"]

  jewel.add_dependency 'activemodel', '>= 3.0.0'
  jewel.add_development_dependency 'rspec'
end

desc 'Generate documentation plugin.'
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ValidatesAirlineData'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Run all rspec tests'
RSpec::Core::RakeTask.new(:test)
