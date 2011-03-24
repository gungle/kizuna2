class PlacesController < ApplicationController
  before_filter :authorize

  # GET /places
  # GET /places.xml
  def index

    # 初期化
    @result = Hash.new
    @result[:result] = "OK"
    @result[:message] = ""

    # ログ出力:
    logger.info("SCOPE2:マップ情報参照:ユーザ=#{Personal.find(session[:personal_id]).full_name}::")
    
    # 該当の組の位置情報を事前に取得しておく。以下の処理でパラメタごとに位置情報を追記する。ただし、災害情報一覧はすべて取得するので、再実行する
    @places = Place.find(:all, :conditions => ["group_id = ? or place_kind = 17", session[:group_id]])
#    @places = Place.find(:all, :conditions => ["group_id = ? or place_kind = 17", 1])
    
    # パラメタにより取得範囲を限定
    if params[:disaster] == "all"
      # 災害情報一覧  ★全範囲で現在の位置情報取得
      @places = Place.find(:all)

      # 災害情報も全部追記 
      adds = Personal.find(:all)
      adds.each{|ad|
        # 該当者の災害情報を取得
        disaster = Disaster.find(:first, :conditions => ["personal_id = ? and now_lat is not null", ad.id])
        if ! disaster.nil? then
          place = setperson(ad, disaster)
          @places << place                            # 追加
        end
      }

    elsif ! params[:group_id].nil?
      # 世帯一覧(GroupID指定)  
      adds = Family.find(:all, :conditions => ["group_id = ? and home_lat is not null", params[:group_id]])
      adds.each{|ad|
        place = Place.new
        place[:place_id] = ""
        place[:group_id] = ad.group_id
        place[:place_title] = ad.family_name + "家"
        place[:place_explain] = ad.address
        place[:place_kind] = 14                       # 家を表す 
        place[:place_lat] = ad.home_lat
        place[:place_lon] = ad.home_lon
        place[:picture_path] = ""
        place[:updated_at] = ad.updated_at
        @places << place                              # 追加
      }
      
    elsif ! params[:family_id].nil?
      # 世帯一覧(GroupID指定)  
      adds = Family.find(:all, :conditions => ["id = ? and home_lat is not null", params[:family_id]])
      adds.each{|ad|
        place = Place.new
        place[:place_id] = ""
        place[:group_id] = ad.group_id
        place[:place_title] = ad.family_name + "家"
        place[:place_explain] = ad.address
        place[:place_kind] = 14                       # 家を表す 
        place[:place_lat] = ad.home_lat
        place[:place_lon] = ad.home_lon
        place[:picture_path] = ""
        place[:updated_at] = ad.updated_at
        @places << place                              # 追加
      }
      
    elsif (! params[:personal_id].nil?) || (params[:disaster] == "one" && params[:personal_id].nil?)
      # 個人情報(個人ID指定) || 災害情報詳細(個人)  今のところ同一の結果を返すので。★現在は避難情報をアップしている人のみ表示
      disaster = Disaster.find(:first, :conditions => ["personal_id = ? and now_lat is not null", params[:personal_id]])
      if ! disaster.nil? then
        ad = Personal.find(params[:personal_id])      # 個人情報取得
        
        # 出力順番を入れ替えるために上書きしている。
        @places = Array.new
        place = setperson(ad, disaster)
        @places << place                              # 追加
        @places = @places + Place.find(:all, :conditions => ["group_id = ? or place_kind = 17", session[:group_id]])
        
#        place = setperson(ad, disaster)
#        @places << place                              # 追加
      end

    end

# ダミーの中心位置を挿入 ===========================
    pl = Place.new
    pl[:group_id] = 1
    pl[:place_title] = "上野地区"
    pl[:place_kind] = 30                       # dummy 
    pl[:place_lat] = 33.224939
    pl[:place_lon] = 131.610321
    pl[:updated_at] = DateTime.now
#p @places    
    @places.unshift pl
# ===============================================

    # レンダリング
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :layout=>false}
    end

  # エラー処理
  rescue => ex
    @result[:result] = "NG"
    @result[:message] = ex.message # + ex.backtrace

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :layout=>false}
    end    
  end

  # 位置情報に人を設定します。
  def setperson(psn, dst)
    place = Place.new
    place[:place_id] = ""
    place[:group_id] = psn.group_id
    place[:place_title] = psn.full_name + "さんの現在位置"
    place[:place_explain] = dst.disaster_memo
#    place[:place_explain] = psn.full_name + "さんの位置です(" + dst.updated_at.strftime("%Y/%m/%d %H:%M:%S") + " 時点)"
    place[:place_kind] = 13                       # 人(11:通常、12:災害弱者、13:被災者)を表す 
    place[:place_lat] = dst.now_lat
    place[:place_lon] = dst.now_lon
    place[:picture_path] = dst.picture_path
    place[:updated_at] = dst.updated_at
    
    return place    
  end
  
  # GET /places/1
  # GET /places/1.xml
  def show
    @place = Place.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @place }
    end
  end

  # GET /places/new
  # GET /places/new.xml
  def new
    @place = Place.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @place }
    end
  end

  # GET /places/1/edit
  def edit
    @place = Place.find(params[:id])
  end

  # POST /places
  # POST /places.xml
  def create
    @place = Place.new(params[:place])

    respond_to do |format|
      if @place.save
        flash[:notice] = 'Place was successfully created.'
        format.html { redirect_to(@place) }
        format.xml  { render :xml => @place, :status => :created, :location => @place }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /places/1
  # PUT /places/1.xml
  def update
    @place = Place.find(params[:id])

    respond_to do |format|
      if @place.update_attributes(params[:place])
        flash[:notice] = 'Place was successfully updated.'
        format.html { redirect_to(@place) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.xml
  def destroy
    @place = Place.find(params[:id])
    @place.destroy

    respond_to do |format|
      format.html { redirect_to(places_url) }
      format.xml  { head :ok }
    end
  end
end
