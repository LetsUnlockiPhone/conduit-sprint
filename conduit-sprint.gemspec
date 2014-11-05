$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'conduit/sprint/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|

  # Details
  #
  s.name     = 'conduit-sprint'
  s.version  = Conduit::Sprint::VERSION
  s.authors  = ['Pedro Martinez', 'Doug Perez']
  s.email    = ['pedro.martinez@hellolabs.com', 'doug.perez@hellolabs.com']
  s.homepage = 'https://github.com/conduit/conduit-sprint'
  s.summary  = 'BeQuick Sprint Driver for Conduit'

  # Files
  #
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  # Dependencies
  #
  s.add_dependency 'excon',   '~> 0.21.0'
  s.add_dependency 'conduit', '~> 0.6.0'
  s.add_dependency 'savon'
  s.add_dependency 'signer'

  # Development Dependencies
  #
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-its'
end
