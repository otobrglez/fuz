# By Oto Brglez - <oto.brglez@opalab.com> 

# http://stackoverflow.com/questions/8419286/how-do-i-use-omniauth-in-rspec-for-sinatra

require 'rubygems'
require 'spork'
require 'database_cleaner'

#require 'spork/ext/ruby-debug'

Spork.prefork do

	require File.join(File.dirname(__FILE__), '..', 'lib/fuz.rb')

	#require 'sinatra'
	require 'rspec'
	require 'rack/test'
	#require 'haml'
	#require "rspec/expectations"

	# Spork.trap_class_method(Rails::Mongoid, :load_models)

	set :environment, :test
	set :run, false
	set :raise_errors, true
	set :logging, false

	RSpec.configure do |conf|
	  conf.include Rack::Test::Methods
	  conf.mock_with :rspec

	  conf.fail_fast = true

	end

	DatabaseCleaner.strategy = :truncation
	DatabaseCleaner.orm = "mongoid"
end

Spork.each_run do
	require File.join(File.dirname(__FILE__), '..', 'lib/fuz.rb')
	DatabaseCleaner.clean  
end







