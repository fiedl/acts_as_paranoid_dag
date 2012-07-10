# -*- encoding: utf-8 -*-
require File.expand_path('../lib/acts_as_dag_with_paranoia/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "acts_as_dag_with_paranoia"
  gem.authors       = ["Sebastian Fiedlschuster"]
  gem.email         = ["sebastian@fiedlschuster.de"]
  gem.description   = %q{Combines acts-as-dag and paranoia to order model instances in a polymorphic directed acyclic graph and to be able to retrieve connections deleted in the past.}
  gem.summary       = %q{Combines acts-as-dag and paranoia to order model instances in a polymorphic directed acyclic graph and to be able to retrieve connections deleted in the past.}
  gem.homepage      = "https://github.com/fiedl/acts_as_dag_with_paranoia"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.require_paths = ["lib"]
  gem.version       = ActsAsDagWithParanoia::VERSION

  gem.add_dependency "rails", ">= 3.2"
  gem.add_dependency "acts-as-dag"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rspec-rails", ">= 2.8.0"
  gem.add_development_dependency "guard", "1.0.1"
  gem.add_development_dependency "nokogiri", ">= 1.5.0"
  gem.add_development_dependency "capybara"
  gem.add_development_dependency 'rspec-rails', '2.10.0'
  gem.add_development_dependency 'guard-rspec', '0.5.5'

  gem.add_development_dependency 'execjs'
  gem.add_development_dependency 'therubyracer'

  gem.add_development_dependency 'sqlite3'

end

