lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "lightweight_attributes"
  spec.version       = '0.2.0'.freeze
  spec.authors       = ["Akira Matsuda"]
  spec.email         = ["ronnie@dio.jp"]

  spec.summary       = 'Good old lightweight attributes for Active Record'
  spec.description   = 'Bring the speed back to your Active Record models!'
  spec.homepage      = 'https://github.com/amatsuda/lightweight_attributes'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', '~> 5.2.0'
  spec.add_development_dependency 'rails', '~> 5.2.0'
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'byebug'
end
