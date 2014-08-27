# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "hbird_notification/version"

Gem::Specification.new do |s|
  s.name        = "hbird_notification"
  s.version     = HbirdNotification::VERSION
  s.platform    = Gem::Platform::RUBY

  s.authors     = ["Colibri Software"]
  s.email       = "info@colibri-software.com"
  s.homepage    = "http://www.colibri-software.com"
  s.summary     = "Locomotive plugin for user notification."

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency 'locomotive_plugins',    '~> 1.1'

  s.required_rubygems_version = ">= 1.3.6"

  s.files           = Dir['Gemfile', '{app,config,db,lib}/**/*']
  s.require_paths   = ["lib"]
end
