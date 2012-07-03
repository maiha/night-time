# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "night-time/version"

Gem::Specification.new do |s|
  s.name        = "night-time"
  s.version     = NightTime::VERSION
  s.authors     = ["maiha"]
  s.email       = ["maiha@wota.jp"]
  s.homepage    = "https://github.com/maiha/night-time"
  s.summary     = %q{NightTime behaves like Time but it also supports out of ranged values}
  s.description = %q{NightTime behaves like Time but it also supports out of ranged values}

  s.rubyforge_project = "night-time"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
end
