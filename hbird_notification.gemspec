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
  s.summary     = "Locomotive plugin for email notifications."
  s.description = "Locomotive plugin that allows designers to send email notifications when content entries are created, saved, and destroyed."
  s.licenses    = ["MIT"]

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency 'locomotive_plugins',    '~> 1.1'

  s.required_rubygems_version = ">= 1.3.6"

  s.files           = Dir['Gemfile', '{app,config,db,lib}/**/*'] + ["MIT-LICENSE", "README.textile"]
  s.require_paths   = ["lib"]
end
