Country.class_eval do
  has_many :cities, :through => :states
end