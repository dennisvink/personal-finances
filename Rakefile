require "rubygems"
require "bundler"
require "dotenv"
require 'sinatra/base'
require 'sinatra/reloader'
require 'dotenv/tasks'

Bundler.setup

Dotenv.load('.env')
Dotenv.load('.env.private')

require "./lib/main"

task :passwd do
  ruby File.expand_path(".", File.dirname(__FILE__)) + "/lib/passwd.rb"
end

task :default, :dotenv do
  if !ENV['PASSWORD']
    Rake::Task["passwd"].invoke
  else
    Finances.run!
  end
end
