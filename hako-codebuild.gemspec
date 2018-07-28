lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hako-codebuild/version"

Gem::Specification.new do |spec|
  spec.name          = "hako-codebuild"
  spec.version       = HakoCodebuild::VERSION
  spec.authors       = ["Sorah Fukumori"]
  spec.email         = ["her@sorah.jp"]

  spec.summary       = %q{Hako script to retrieve a latest commit from AWS CodeBuild as a image tag}
  spec.homepage      = "https://github.com/sorah/hako-codebuild"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-codebuild"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
