# By Oto Brglez - <oto.brglez@opalab.com>

require 'kaminari/models/mongoid_extension'


class Pim
  include Mongoid::Document
  include Kaminari::MongoidExtension::Criteria
  include Kaminari::MongoidExtension::Document

  paginates_per 20
  
  belongs_to :source
  
  field :pid
  field :pim_type, type: String
  field :provider, type: String
  field :created_at, type: Integer #, default: ->(){ DateTime.now }
  field :message, type: String
  
  index :pid, unique: true
  index :pim_type
  
  field :link, type: String
  field :name, type: String
  field :caption, type: String
  field :icon, type: String
  field :picture, type: String
  
  field :location, type: Array
  index [[ :location, Mongo::GEO2D ]]
  
  validates_uniqueness_of :pid
  
  #default_scope order(:created_at,"desc")
  scope :all, order_by(:created_at => :desc)

  def message
    Rinku.auto_link read_attribute("message").to_s
    # 
  end
end