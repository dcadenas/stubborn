# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stubborn}
  s.version = "0.1.2"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Cadenas"]
  s.date = %q{2009-10-02}
  s.email = %q{dcadenas@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]

  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/missed_stub_exception.rb",
     "lib/stubborn.rb",
     "lib/suggesters/rspec_suggester.rb",
     "stubborn.gemspec",
     "test/stubborn_method_filtering_test.rb",
     "test/stubborn_test.rb",
     "test/suggesters/rspec_suggester_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/dcadenas/stubborn}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{stubborn}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{A gem to help you find your missing stubs}
  s.test_files = [
    "test/stubborn_method_filtering_test.rb",
     "test/stubborn_test.rb",
     "test/suggesters/rspec_suggester_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
