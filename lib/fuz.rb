# By Oto Brglez - <oto.brglez@opalab.com>

require "bundler"
Bundler.require

require 'sinatra/base'
# require 'sinatra/reloader'
require "mongoid"
require "haml"
require 'rinku'

require "./lib/facebook_provider.rb"
require "./lib/twitter_provider.rb"
require "./lib/rss_provider.rb"
require "./lib/youtube_provider.rb"
require "./lib/github_provider.rb"
require "./lib/models/pim.rb"
require "./lib/models/source.rb"

# require "ruby-debug"

class Fuz < Sinatra::Base

	configure [:development, :test] do Mongoid.logger = Logger.new($stdout); end
	configure :production do Mongoid.logger=Logger.new('/dev/null'); end
	configure do Mongoid.load!("config/mongoid.yml"); end

	use Rack::Session::Cookie
	
	use OmniAuth::Builder do
	  provider :facebook, ENV['FUZ_FB_KEY'], ENV['FUZ_FB_SECRET'], { scope: 'offline_access,read_stream'}
	  provider :twitter, ENV['FUZ_TW_KEY'], ENV['FUZ_TW_SECRET']
	end
	 
	set :views, 'views'
	set :public_folder, 'public'

	get '/' do
		@pims = Pim.all.page(1)
		haml :index
	end

	get '/fuz.css' do
		content_type 'text/css'
  		response['Expires'] = (Time.now + 60*60*24*356*3).httpdate if production?
		scss :fuz
	end
	
	get '/auth/:provider/callback' do
	  source = Source.find_or_create(request.env['omniauth.auth'])
	  redirect "/"  
  	end

=begin  
	get '/sources' do
		@sources = Source.all
		haml :sources
	end

	get '/feed/:provider/:uid' do
		@items = Source.where(provider:params[:provider],uid:params[:uid]).first.feed
		@items.to_json
	end
=end

	get '/:page' do
		@pims = Pim.all.page(params[:page].to_i)
		haml :index
	end

	helpers
		def relative_time_ago(from_time)
			from_time = DateTime.strptime(from_time.to_s,'%s')
			distance_in_minutes = (((Time.now - from_time.to_time).abs)/60).round
			case distance_in_minutes
			when 0..1 then 'about a minute'
			when 2..44 then "#{distance_in_minutes} minutes"
			when 45..89 then 'about 1 hour'
			when 90..1439 then "about #{(distance_in_minutes.to_f / 60.0).round} hours"
			when 1440..2439 then '1 day'
			when 2440..2879 then 'about 2 days'
			when 2880..43199 then "#{(distance_in_minutes / 1440).round} days"
			when 43200..86399 then 'about 1 month'
			when 86400..525599 then "#{(distance_in_minutes / 43200).round} months"
			when 525600..1051199 then 'about 1 year'
			else "over #{(distance_in_minutes / 525600).round} years"
			end
	end	
end