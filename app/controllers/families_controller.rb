class FamiliesController < ApplicationController
  before_filter :authorize

  # GET /families
  # GET /families.xml
  def index

    # 初期化
    @result = Hash.new
    @result[:result] = "OK"
    @result[:message] = ""

    # ログ出力:
    logger.info("SCOPE2:世帯情報一覧:ユーザ=#{Personal.find(session[:personal_id]).full_name}::")
    
    # パラメタにより取得範囲を限定
    if ! params[:group_id].nil?
      # GroupID指定
      @families = Family.find_all_by_group_id(params[:group_id])
    elsif ! params[:family_id].nil?
      # 家族ID指定
      @families = Family.find_all_by_id(params[:family_id])
    else    
      # それ以外
      @families = Family.find(:all)
    end
    
    # その他の必要な情報を設定
    @families.each{|fm|
      fm[:group_name] = Group.find(fm.group_id).group_name                            # 世帯名を設定
      fm[:family_number] = Personal.count(:conditions => ["family_id = ?", fm.id])    # 家族数を設定
      cnt = Personal.count(:conditions => ["family_id = ? and weak_kind = 1", fm.id]) # 災害弱者の数を設定
      fm[:weak_kind] = (cnt > 0) ? 1 : 0
    }

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

  # GET /families/1
  # GET /families/1.xml
  def show
    @family = Family.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @family }
    end
  end

  # GET /families/new
  # GET /families/new.xml
  def new
    @family = Family.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @family }
    end
  end

  # GET /families/1/edit
  def edit
    @family = Family.find(params[:id])
  end

  # POST /families
  # POST /families.xml
  def create
    @family = Family.new(params[:family])

    respond_to do |format|
      if @family.save
        flash[:notice] = 'Family was successfully created.'
        format.html { redirect_to(@family) }
        format.xml  { render :xml => @family, :status => :created, :location => @family }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @family.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /families/1
  # PUT /families/1.xml
  def update
    @family = Family.find(params[:id])

    respond_to do |format|
      if @family.update_attributes(params[:family])
        flash[:notice] = 'Family was successfully updated.'
        format.html { redirect_to(@family) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @family.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /families/1
  # DELETE /families/1.xml
  def destroy
    @family = Family.find(params[:id])
    @family.destroy

    respond_to do |format|
      format.html { redirect_to(families_url) }
      format.xml  { head :ok }
    end
  end
end
