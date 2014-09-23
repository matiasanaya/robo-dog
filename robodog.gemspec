Gem::Specification.new do |spec|
  spec.name          = 'robodog'
  spec.version       = '0.0.1'
  spec.authors       = ['Matias Anaya']
  spec.email         = ['matiasanaya@gmail.com']
  spec.summary       = %q{Fredwina the Farmer's robotic sheep dog simulator}
  spec.description   = %q{Fredwina the Farmer's robotic sheep dog simulator, used for the shock and awe showcase.}
  spec.homepage      = 'https://github.com/matiasanaya/robo-dog'
  spec.license       = 'UNLICENSE'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['robodog']
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.1'

  spec.add_development_dependency 'rspec', '~> 3.1'
end
