version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name        = 'dynamic_attrs'
  s.version     = version
  s.summary     = 'Dynamic attributes for ActiveRecord!'
  s.description = 'Dynamic Attrs is a customizable database column library for ActiveRecord.'
  s.authors     = ['Kaid Wong']
  s.email       = 'kaid@kaid.me'
  s.files       = Dir.glob('lib/**/*[^(~|#)]') + %w(dynamic_attrs.gemspec VERSION)
  s.homepage    = 'http://github.com/kaid/dynamic_attrs'

  s.required_ruby_version = '>= 2.0'

  s.add_dependency('activerecord', '>= 3.2.12')
  s.add_dependency('railties', '>= 3.2.12')

  s.add_development_dependency('rspec', '~> 2.13.0')
  s.add_development_dependency('sqlite3', '~> 1.3.7')
  s.add_development_dependency('database_cleaner', '~> 0.9.1')
  s.add_development_dependency('factory_girl', '~> 4.2.0')
end
