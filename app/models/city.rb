class City < ActiveRecord::Base
  has_one :zone_member, :as => :zoneable
  has_one :zone, :through => :zone_member
  belongs_to :state
  has_one :country, :through => :state
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:state_id]
  
  def state_and_city
    if state
      state.name + '- ' + name
    else
      name
    end
  end
end
