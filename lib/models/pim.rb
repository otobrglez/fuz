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

  scope :with_location, ->(){
    unscoped.where({
      :location.nin => ["",nil,[]],
      :location.ne => nil}
    ).order_by(:created_at,:desc)
  }

  def self.center_location
    return self.with_location.limit(1).to_a.map(&:location).first
    locations = self.with_location.to_a.map(&:location)
    max_x, max_y = locations.first
    min_x, min_y = locations.first

    locations.each do |l|
      l_x, l_y = l
      max_x = l_x if l_x > max_x
      max_y = l_y if l_y > max_y
      min_x = l_x if l_x < min_x
      min_y = l_y if l_y < min_y
    end



    [
      (max_x + min_x).fdiv(2),
      (max_y + min_y).fdiv(2)
    ]
  end
end