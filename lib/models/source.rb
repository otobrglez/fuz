# By Oto Brglez - <oto.brglez@opalab.com>

class Source
  
  include Mongoid::Document
  
  field :provider, type: String
  field :uid, type: String
  field :token, type: String
  field :secret, type: String
  field :nickname, type: String
  
  field :options, type: Hash
  
  index :provider
  index :uid
  
  has_many :pims

  validates_presence_of :provider, :uid
  
  def self.find_or_create auth
    source_f = Source.new(provider: auth[:provider],
      uid: auth[:uid],
      token: auth[:credentials][:token],
      secret: auth[:credentials][:secret],
      nickname: auth[:info][:nickname])
    source_d = Source.where(provider: source_f.provider, uid: source_f.uid).first
    
    if source_d.nil? # New source
      source_f.save if source_f.valid?
      return source_f
    else # Existing srouce - Update token.
      source_d.token = source_f.token
      source_d.secret = source_f.secret
      source_d.save
      return source_d
    end
  end
  
  def to_s
    "#{self.provider}(#{self.uid})"
  end
  
  def feed options={}
    klass = "#{self.provider.capitalize}Provider"
    klass = Object.const_defined?(klass) ? Object.const_get(klass) : Object.const_missing(klass)
    klass.new(self).feed(options)
  end
  
  def self.import_feeds
    pims_start = Pim.count
    Source.all.each do |source|
      items = source.feed
      items.map(&:save)      
    end
    pims_end = Pim.count
    pims_end-pims_start
  end
  
end