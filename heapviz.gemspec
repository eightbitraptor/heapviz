# frozen_string_literal: true

require_relative "lib/heapviz/version"

Gem::Specification.new do |spec|
  spec.name = "heapviz"
  spec.version = Heapviz::VERSION

  spec.authors = ["Matt Valentine-House"]
  spec.email = ["matt@eightbitraptor.com"]

  spec.summary = "Visualise a Ruby heap dump output from ObjectSpace.dump_all"
  spec.description = "Visualise a Ruby heap dump output from ObjectSpace.dump_all"
  
  spec.license = "MIT"

  spec.homepage = "https://github.com/eightbitraptor/heapviz"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.bindir = "exe"
  spec.executables = ["heapviz"]

  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "chunky_png", "~> 1.4.0"

  spec.add_development_dependency "minitest", "~> 1.4.0"
  spec.add_development_dependency "rake", "~> 13.0.0"
  spec.add_development_dependency "mocha", "~> 1.13.0"
end
