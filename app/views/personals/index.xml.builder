xml.personals(:type => "array") do
  xml.mode(getmode())
  xml.result(getresultcode(@result[:result]))
  if @result[:result] == "NG"
    xml.message(@result[:message])
  else    
    @personals.each do |personal|
      xml.personal do
        xml.personal_id(personal.id, :type => "integer")
        xml.family_id(personal.family_id, :type => "integer")
        xml.family_name(personal.family_name, :type => "string")
        xml.full_name(personal.full_name, :type => "string")
        xml.address(personal.address, :type => "string")
        xml.age(age(personal.birthday), :type => "integer") 
        xml.blood(personal.blood, :type => "integer")
        xml.sex(personal.sex, :type => "integer")
        xml.personal_tel(personal.personal_tel, :type => "string")
        xml.weak_kind(personal.weak_kind, :type => "integer")
        xml.job(personal.job, :type => "string")
        xml.good_field(personal.good_field, :type => "string")
        xml.medical_history(personal.medical_history, :type => "string")
        xml.icon_path(personal.icon_path, :type => "string")
        xml.access_kind(personal.access_kind, :type => "integer")
        xml.disaster_memo(personal.memo, :type => "string")
        xml.updated_at(personal.updated_at.strftime("%Y/%m/%d %H:%M:%S"), :type => "datetime")        
      end
    end
  end
end