Gem::Specification.new do |s|
  s.name = %q{batchbook}
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Will Larson", "Eric Krause"]
  s.date = Time.now
  s.description = %q{Wrapper for BatchBook XML API}
  s.email = ["technical@batchblue.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/batchbook.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/batchblue/batchbook}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.signing_key = %q{/Users/erickrause/.gem/gem-private_key.pem}
  s.summary = %q{Wrapper for BatchBook XML API}

  s.add_dependency(%q<activeresource>, [">= 2.3.5"])
end
