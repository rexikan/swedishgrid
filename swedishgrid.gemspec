# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{swedishgrid}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Magnus Enarsson"]
  s.date = %q{2009-05-05}
  s.email = %q{magnus@icehouse.se}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "lib/swedishgrid.rb",
    "test/swedishgrid_test.rb",
    "test/test_helper.rb"
  ]
  s.has_rdoc = true
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Convert coordinates between geodetic WGS84 and Swedish grid RT90 and SWEREF99 systems.}
  s.test_files = [
    "test/swedishgrid_test.rb",
    "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
