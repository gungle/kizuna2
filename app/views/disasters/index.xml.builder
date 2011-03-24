xml.disaster(:type => "array") do
  xml.mode(getmode())
  xml.result(getresultcode(@result[:result]))
  if @result[:result] == "NG"
    xml.message(@result[:message])
  else    
    if @result[:viewkind] == "detail"
      # 詳細表示モード
      @disasters.each do |disaster|
        xml.personal do
          xml.personal_id(disaster.id, :type => "integer")
          xml.full_name(disaster.full_name, :type => "string")
          xml.age(age(disaster.birthday), :type => "integer") 
          xml.blood(disaster.blood, :type => "integer")
          xml.sex(disaster.sex, :type => "integer")
          xml.emergency_kind(disaster.emergency_kind, :type => "integer")
          xml.disaster_status_kind(disaster.disaster_status_kind, :type => "integer")
          xml.done_kind(disaster.done_kind, :type => "integer")
          xml.triage_kind(disaster.triage_kind, :type => "integer")
          xml.disaster_memo(disaster.disaster_memo, :type => "string")
          xml.picture_path(disaster.picture_path, :type => "string")
          xml.updated_at(disaster.updated_at.strftime("%Y/%m/%d %H:%M:%S"), :type => "datetime")
        end
      end
    else
      # 一覧表示モード
      xml.groups(:type => "array") do
        @disasters.each do |disaster|
          # 各組ごとにループ
          xml.group do
            xml.group_id(disaster.id, :type => "integer")           # 組ID
            xml.group_name(disaster.group_name, :type => "string")  # 組名
            
            # 各組の世帯の安否情報
            safeties = disaster.safeties
            xml.safeties(:type => "array") do
              safeties.each do |safety|
                if safety.report == 0 # 安否報告なし (世帯情報)
                  xml.safety(:mode => "2") do
                    xml.family_id(safety.id, :type => "integer")
                    xml.family_name(safety.family_name + " 家", :type => "string")
                    xml.status(safety.status, :type => "integer")
                  end
                  
                elsif safety.report == 1 # 安否報告あり (個別情報　複数あり)
                  persons = safety.persons
                  persons.each do |person|
                    xml.safety(:mode => "1")  do
                      xml.personal_id(person.personal_id, :type => "integer")
                      xml.full_name(person.full_name, :type => "string")
                      xml.age(age(person.birthday), :type => "integer")
                      xml.sex(person.sex, :type => "integer")
                      xml.personal_safety_kind(person.personal_safety_kind, :type => "integer")
                    end
                  end
                end
                
              end
            end # 各組の安否情報END ===============
        
            # 各組の被災者情報
            disas = disaster.disas
            xml.helps(:type => "array") do
              disas.each do |dis|
               xml.help do
#p dis                 
                 xml.personal_id(dis.personal_id, :type => "integer")
                 xml.full_name(dis.full_name, :type => "string")
                 xml.age(age(dis.birthday), :type => "integer")
                 xml.sex(dis.sex, :type => "integer")
                 xml.emergency_kind(dis.emergency_kind, :type => "integer")
                 xml.disaster_status_kind(dis.disaster_status_kind, :type => "integer")
                 xml.done_kind(dis.done_kind, :type => "integer")
                 xml.triage_kind(dis.triage_kind, :type => "integer")
                 xml.disaster_memo(dis.disaster_memo, :type => "string")
                 
               end
              end
            end # 各組の被災者情報END ===============
        
            # 各組の安否情報
            weaks = disaster.weaks
            xml.weaks(:type => "array") do
              weaks.each do |weak|
               xml.weak do
                 xml.personal_id(weak.id, :type => "integer")
                 xml.full_name(weak.full_name, :type => "string")
                 xml.age(age(weak.birthday), :type => "integer")
                 xml.sex(weak.sex, :type => "integer")
                 xml.done_kind(weak.done_kind, :type => "integer")
               end
              end
            end # 各組の安否情報END ===============
        
          end
        end
      end      
    end
  end
end