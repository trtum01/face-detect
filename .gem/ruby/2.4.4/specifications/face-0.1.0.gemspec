# -*- encoding: utf-8 -*-
# stub: face 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "face".freeze
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Roc Yu".freeze]
  s.date = "2013-08-25"
  s.description = "".freeze
  s.email = ["rociiu.yu@gmail.com".freeze]
  s.homepage = "http://rubygems.org/gems/face".freeze
  s.licenses = ["MIT".freeze]
  s.rubyforge_project = "face".freeze
  s.rubygems_version = "2.6.14.1".freeze
  s.summary = "Ruby wraper of SkyBiometry Face Detection and Recognition API".freeze

  s.installed_by_version = "2.6.14.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>.freeze, [">= 1.6.1"])
      s.add_runtime_dependency(%q<json>.freeze, [">= 1.4.6"])
    else
      s.add_dependency(%q<rest-client>.freeze, [">= 1.6.1"])
      s.add_dependency(%q<json>.freeze, [">= 1.4.6"])
    end
  else
    s.add_dependency(%q<rest-client>.freeze, [">= 1.6.1"])
    s.add_dependency(%q<json>.freeze, [">= 1.4.6"])
  end
end
