class City < ActiveRecord::Base
  belongs_to :state
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:state_id]
end
