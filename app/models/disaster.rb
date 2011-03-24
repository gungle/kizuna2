class Disaster < ActiveRecord::Base
  belongs_to :personal

  validates_presence_of(:personal_id, :group_id, :emergency_kind, :disaster_status_kind, :triage_kind, :done_kind) 
  validates_inclusion_of(:emergency_kind, :in =>0..4)
#  validates_inclusion_of(:disaster_status_kind, :in =>1..2)
  validates_inclusion_of(:triage_kind, :in =>0..4)
  validates_inclusion_of(:done_kind, :in =>0..1)
  
  
  def picture= (picture)

    if picture != ""
      # パスの生成
      url_path = PATH_PIC_DISASTERS + Time.now.strftime("%Y%m%d%H%M%S") + ".jpg"
      file_path = RAILS_ROOT + PATH_PIC_TOP + url_path

      # 画像の取り込みと保存
      img = picture.read
      foo = File.open(file_path,'w')
      foo.write img
      foo.close
      
      # ファイルのURL相対パス格納
      self.picture_path = url_path
    end

  end
    
#  def base_part_of(file_name)
#    name = File.basename(file_name)
#    name.gsub(/[^¥w._-]/, '')
#  end
  
end
