# By Oto Brglez - <oto.brglez@opalab.com>
require "twitter"

class TwitterProvider
  attr_accessor :uid, :token, :source, :secret
  
  #include HTTParty
  #base_uri 'https://api.twitter.com'
  #format :json
  
  def initialize source
    @source, @uid, @token, @secret = source, source.uid, source.token, source.secret
    
    Twitter.configure do |config|
      config.consumer_key = ENV['FUZ_TW_KEY']
      config.consumer_secret = ENV['FUZ_TW_SECRET']
      config.oauth_token = source.token
      config.oauth_token_secret = source.secret
    end
    
    self
  end
  
  def to_pim tw_item
    Pim.new(
      message: (tw_item['text']),
      pim_type: "message",
      created_at: tw_item['created_at'],
      pid: tw_item['id'].to_s,
      source: source,
      provider: source.provider,
      location: (not(tw_item["geo"].nil?) ? tw_item["geo"]["coordinates"] : nil)
      #link: fb_item['link'],
      #name: fb_item['name'],
      #caption: fb_item['caption'],
      #icon: fb_item['icon'],
      #picture: fb_item['picture']
    )    
  end
  
  def feed options={}
    out = Twitter.user_timeline
    return out.map!{|item| to_pim(item) } unless out.empty?
    []
  end
  
end