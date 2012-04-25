# By Oto Brglez - <oto.brglez@opalab.com>

require "bundler"
Bundler.require

require 'sinatra/base'
require 'sinatra/reloader'
require "mongoid"
require "haml"

# require "ruby-debug"


class Fuz < Sinatra::Base

	configure :development do
		register Sinatra::Reloader
		also_reload "#{Dir.pwd}/models/*"
	end

	configure [:development, :test] do Mongoid.logger = Logger.new($stdout); end
	configure :production do Mongoid.logger=Logger.new('/dev/null'); end
	configure do Mongoid.load!("config/mongoid.yml"); end

	#use Rack::Session::Cookie
	
	#use OmniAuth::Builder do
	#  provider :facebook, ENV['GROUPAPP_FB_KEY'], ENV['GROUPAPP_FB_SECRET'], { scope: 'user_groups'}
	#end
		
	set :views, 'views'

	get '/' do
		haml :index
	end

	get '/fuz.css' do
		content_type 'text/css'
  		response['Expires'] = (Time.now + 60*60*24*356*3).httpdate if production?
		scss :fuz
	end

end