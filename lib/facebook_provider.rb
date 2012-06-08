# By Oto Brglez - <oto.brglez@opalab.com>

class FacebookProvider
  attr_accessor :uid, :token, :source
  
  include HTTParty
  base_uri 'https://graph.facebook.com'
  format :json

  def initialize source
    @source, @uid, @token = source, source.uid, source.token
  end
  
  def to_pim fb_item
    Pim.new(
      message: (fb_item['message'] || fb_item['story']),
      pim_type: fb_item['type'],
      created_at: fb_item['updated_time'],
      pid: fb_item['id'],
      source: source,
      provider: source.provider,
      link: fb_item['link'],
      name: fb_item['name'],
      caption: fb_item['caption'],
      icon: fb_item['icon'],
      picture: fb_item['picture'],
      location: (not(fb_item['place'].nil?) ? ([ fb_item['place']['location']['latitude'], fb_item['place']['location']['longitude']]) : [])
    )
  end

  def feed options={}
    out = self.class.get("/#{uid}/feed",query:{
      limit: 100,
      date_format:"U",
      access_token:token
    })
 
    return out['data'].map!{|item| to_pim(item) } unless out['data'].empty?
    []
  end

end