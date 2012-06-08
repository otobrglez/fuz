require "spec_helper"
require "fuz"

set :environment, :test

describe Fuz do

	def app
		@app ||= Fuz.new
	end

	it "GET '/' " do
		get '/'
		last_response.should be_ok
	end

=begin

	it "has '/fuz.css' " do
		get '/fuz.css'
		puts last_response.body
		last_response.should be_ok
	end

	it "has '/10-longboarding' " do
		get '/10-longboarding'
		last_response.should be_ok
	end

	it "has '/10-longboarding/10-mypost" do
		get '/10-longboarding/10-mypost'
		last_response.should be_ok
	end
=end
	it "should respond to '/dejan'" do
		get '/dejan'
		last_response.should be_ok
	end


end