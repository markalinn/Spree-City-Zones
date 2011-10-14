Zone.class_eval do
  def include?(address)
    return false unless address

    # NOTE: This is complicated by the fact that include? for HMP is broken in Rails 2.1 (so we use awkward index method)
    members.any? do |zone_member|
      case zone_member.zoneable_type
      when "Zone"
        zone_member.zoneable.include?(address)
      when "Country"
        zone_member.zoneable == address.country
      when "City"
        zone_member.zoneable == City.find(:first, :conditions => ['UPPER(name) = :name and state_id = :state_id', {:name => address.city.upcase, :state_id => address.state.id}])
        #Break out of case statement and don't look up state
        break
      when "State"
        zone_member.zoneable == address.state
      else
        false
      end
    end
  end
end