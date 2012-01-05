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
        #Break out so State Zones aren't also found for taxation
        #this allows a default state tax if no city found.... probably breaks shipping calculators though?!?!
        break
      when "State"
        zone_member.zoneable == address.state
      else
        false
      end
    end
  end

  def kind
    member = self.members.last
    case member && member.zoneable_type
    when "City"   then "city"
    when "State"  then "state"
    when "Zone"   then "zone"
    else
      "country"
    end
  end

  def country_list
    members.map {|zone_member|
      case zone_member.zoneable_type
      when "Zone"
        zone_member.zoneable.country_list
      when "Country"
        zone_member.zoneable
      when "State"
        zone_member.zoneable.country
      when "City"
        zone_member.zoneable.country_list
      else
        nil
      end
    }.flatten.compact.uniq
  end
  
end