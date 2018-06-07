lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "string-builder"
  spec.version       = "2.1.1"
  spec.authors       = ["Edwin Onuonga"]
  spec.email         = ["edwinonuonga@gmail.com"]

  spec.summary       = %q{Modified and extended port of the String::Builder IO-style initializer for the String class of the Crystal programming language.}
  spec.homepage      = "https://www.github.com/eonu/string-builder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.7"
end
