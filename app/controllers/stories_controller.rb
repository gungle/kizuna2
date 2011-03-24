class StoriesController < ApplicationController
  
  def init
    # 実証実験用にDBを初期設定する

    # 平常時モードにする
    Mode.update_all("mode_kind = 0")
    
    # 組情報の災害共有をOFFにする
    Group.update_all("share_disaster_kind = 0")
    
    # 安否確認を削除する
    Personalsafety.delete_all()
    
    # 災害情報を削除する
    Disaster.delete_all()
    
    # 地図上から災害情報を削除する
    Place.delete_all("place_kind = 13 or place_kind = 17")
    
    respond_to do |format|
        flash[:notice] = 'init successfully.'
        format.html { redirect_to(:controller => :logins, :action => :top) }
        format.xml  { head :ok }
    end
   
  end

  
  def disaster1
    # 災害情報登録 

    # 安否情報を登録する
    Personalsafety.create(
      [
        # A組
        {:personal_id => "10", :group_id => "1", :family_id => "8",  :personal_safety_kind => "1"}, # 鈴木俊男
        {:personal_id => "6", :group_id => "1", :family_id => "4",  :personal_safety_kind => "1"}, # 栗林芳子
        {:personal_id => "7", :group_id => "1", :family_id => "5",  :personal_safety_kind => "1"}, # 神崎ゆり
        {:personal_id => "8", :group_id => "1", :family_id => "6",  :personal_safety_kind => "2"}, # 池田シズエ(*)
        # B組
        {:personal_id => "1", :group_id => "2", :family_id => "1",  :personal_safety_kind => "1"}, # 佐藤和男
        {:personal_id => "9",  :group_id => "2", :family_id => "7",  :personal_safety_kind => "2"}, # 菊川克也(*)
        {:personal_id => "11", :group_id => "2", :family_id => "9",  :personal_safety_kind => "1"}, # 永松みき
        {:personal_id => "12", :group_id => "2", :family_id => "10", :personal_safety_kind => "1"}, # 清水大介
        {:personal_id => "13", :group_id => "2", :family_id => "11", :personal_safety_kind => "2"}, # 野口なつみ(*)
        # C組
        {:personal_id => "14", :group_id => "3", :family_id => "12", :personal_safety_kind => "1"}, # 大原秀樹
        {:personal_id => "15", :group_id => "3", :family_id => "13", :personal_safety_kind => "1"}, # 松村夕子
        {:personal_id => "16", :group_id => "3", :family_id => "14", :personal_safety_kind => "1"}, # 今井さとみ
        {:personal_id => "17", :group_id => "3", :family_id => "15", :personal_safety_kind => "2"}  # 柴山幸三(*)

      ])

    # 災害情報を登録する
    Disaster.create(
      [
        {:personal_id => "8", :group_id => "1", :emergency_kind => "4", :disaster_status_kind => "3", :triage_kind => "3", :done_kind => "0", :now_lat => "33.224602", :now_lon => "131.608658", :picture_path => "/images/disasters/disaster2.jpg", :disaster_memo => "家が半壊した。シズエは，大きなケガはないようだが，強いショックを受けている。弱々しく助けを呼んでいる。シズエは目が悪く自力では脱出できない。家から外に出し，避難所に連れて行きたい（２人必要）。連れて行く避難所も決める必要あり。"}, # 池田シズエ
        {:personal_id => "9", :group_id => "2", :emergency_kind => "4", :disaster_status_kind => "4", :triage_kind => "3", :done_kind => "0", :now_lat => "33.223857", :now_lon => "131.609859", :picture_path => "/images/disasters/disaster1.jpg", :disaster_memo => "寝ていた菊川克也の上に重たいタンスが倒れた。足がタンスの下敷きになり骨折。大声で痛がっている。タンスを持ち上げ救出し，外科病院に連れていきたい（３人必要）。病院も決める必要あり。"}, # 菊川克也
        {:personal_id => "13", :group_id => "2", :emergency_kind => "4", :disaster_status_kind => "3", :triage_kind => "3", :done_kind => "0", :now_lat => "33.224216 ", :now_lon => "131.609951", :picture_path => "/images/disasters/disaster3.jpg", :disaster_memo => "２階の寝室に閉じ込められた。寝室のドアを壊して，なつみを２階から１階に降ろしたい（１人必要）。"}, # 野口ゆか 
        {:personal_id => "17", :group_id => "3", :emergency_kind => "4", :disaster_status_kind => "1", :triage_kind => "3", :done_kind => "0", :now_lat => "33.224733", :now_lon => "131.607338", :picture_path => "/images/disasters/disaster4.jpg", :disaster_memo => "上野の墓地公園に朝の散歩に行っている。幸三の居場所はiPhoneの地図の通り。幸三を探しに行き，避難所に連れていきたい（２人必要）。避難所も決める必要あり。"} # 柴山幸三
      ])

    respond_to do |format|
        flash[:notice] = 'disaster1 successfully.'
        format.html { redirect_to(:controller => :logins, :action => :top) }
        format.xml  { head :ok }
    end
  end
  
  
  def disaster2
    # 災害情報登録2 位置情報を登録する
    Place.create(
      [
        {:group_id => "1", :place_kind => "17", :place_title => "道路が断裂", :place_explain => "塀が倒れ通行不可", :place_lat => "33.224679", :place_lon => "131.610503" },
        {:group_id => "2", :place_kind => "17", :place_title => "がけ崩れ", :place_explain => "上野墓地後援の近く", :place_lat => "33.223045", :place_lon => "131.608304" },
        {:group_id => "3", :place_kind => "17", :place_title => "道路が断裂", :place_explain => "大きな亀裂が入っており通行不可", :place_lat => "33.222368", :place_lon => "131.611077" },
        {:group_id => "1", :place_kind => "17", :place_title => "電柱が倒壊", :place_explain => "電線から放電している可能性があり危険", :place_lat => "33.224418", :place_lon => "131.608862" },
        {:group_id => "2", :place_kind => "17", :place_title => "建物が倒壊", :place_explain => "建物が倒れ近隣民家も倒壊", :place_lat => "33.223898", :place_lon => "131.609677" },
        {:group_id => "3", :place_kind => "17", :place_title => "電柱、建物が倒壊", :place_explain => "道路が塞がれ通行不可", :place_lat => "33.223943", :place_lon => "131.612381" },
        {:group_id => "3", :place_kind => "17", :place_title => "電柱、建物が倒壊", :place_explain => "道路が塞がれ通行不可", :place_lat => "33.223763", :place_lon => "131.613421" }
      ])
    
    
    respond_to do |format|
        flash[:notice] = 'disaster2 successfully.'
        format.html { redirect_to(:controller => :logins, :action => :top) }
        format.xml  { head :ok }
    end
    
  end
  
  
end
