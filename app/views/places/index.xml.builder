xml.places(:type => "array") do
  xml.mode(getmode())
  xml.result(getresultcode(@result[:result]))
  if @result[:result] == "NG"
    xml.message(@result[:message])
  else    
    @places.each do |place|
      xml.place do
        xml.place_id(place.id, :type => "integer")
        xml.group_id(place.group_id, :type => "integer")
        xml.place_title(place.place_title, :type => "string")
        xml.place_explain(place.place_explain, :type => "string")
        xml.place_kind(place.place_kind, :type => "integer")
        xml.place_lat(place.place_lat, :type => "float")
        xml.place_lon(place.place_lon, :type => "float")
        xml.picture_path(place.picture_path, :type => "string")
        xml.updated_at(place.updated_at.strftime("%Y/%m/%d %H:%M:%S"), :type => "datetime")        
      end
    end
  end
end