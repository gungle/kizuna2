xml.families(:type => "array") do
  xml.mode(getmode())
  xml.result(getresultcode(@result[:result]))
  if @result[:result] == "NG"
    xml.message(@result[:message])
  else    
    @families.each do |family|
      xml.family do
        xml.family_id(family.id, :type => "integer")
        xml.group_id(family.group_id, :type => "integer")
        xml.group_name(family.group_name, :type => "string")
        xml.family_name(family.family_name, :type => "string")
        xml.family_number(family.family_number, :type => "integer")
        xml.weak_kind(family.weak_kind, :type => "integer")
        xml.address(family.address, :type => "string")
        xml.home_tel(family.home_tel, :type => "string")
        xml.home_lat(family.home_lat, :type => "float")
        xml.home_lon(family.home_lon, :type => "float")
        xml.updated_at(family.updated_at.strftime("%Y/%m/%d %H:%M:%S"), :type => "datetime")        
      end
    end
  end
end