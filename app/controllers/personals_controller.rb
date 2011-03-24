class PersonalsController < ApplicationController
  before_filter :authorize
  
  # GET /personals
  # GET /personals.xml
  def index
    
    # 初期化
    @result = Hash.new
    @result[:result] = "OK"
    @result[:message] = ""

    # ログ出力:
    logger.info("SCOPE2:個人情報参照:ユーザ=#{Personal.find(session[:personal_id]).full_name}::")

    # パラメタにより取得範囲を限定
    if ! params[:group_id].nil?
      # GroupID指定 
      @personals = Personal.find_all_by_group_id(params[:group_id])
    elsif ! params[:family_id].nil?
      # 家族ID
      @personals = Personal.find_all_by_family_id(params[:family_id])
    elsif ! params[:personal_id].nil?
      # 個人ID指定
      @personals = Personal.find_all_by_id(params[:personal_id])
    else    
      # それ以外
      @personals = Personal.find(:all)
    end

    # アクセス制御(共有、分散条件)取得
    access_kind = Access.find(:first).access_kind
    
    # その他の必要な情報を設定
    @personals.each{|ps|
      family = Family.find(ps[:family_id])    # 当該の家族情報取得
      ps[:family_name] = family.family_name   # 世帯名を設定
      ps[:address] = family.address           # 住所を設定

      # 災害情報メモのデフォルト値(実証実験のため)
      memo = Disastermemo.find_by_personal_id(ps.id)
      ps[:memo] = memo.nil? ? "" : memo.disaster_memo

      # アクセス制御設定(実証実験のため)
      if !params[:access].nil? &&session[:group_id] != family.group_id && access_kind == 0 
        # accessパラメータが設定されている && 同一のグループでない && 他組の閲覧不可 
        ps[:access_kind] = 0  # 閲覧NG
      else
        ps[:access_kind] = 1  # 閲覧OK
      end
    
      
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

  # GET /personals/1
  # GET /personals/1.xml
  def show
    @personal = Personal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @personal }
    end
  end

  # GET /personals/new
  # GET /personals/new.xml
  def new
    @personal = Personal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @personal }
    end
  end

  # GET /personals/1/edit
  def edit
    @personal = Personal.find(params[:id])
  end

  # POST /personals
  # POST /personals.xml
  def create
    @personal = Personal.new(params[:personal])

    respond_to do |format|
      if @personal.save
        flash[:notice] = 'Personal was successfully created.'
        format.html { redirect_to(@personal) }
        format.xml  { render :xml => @personal, :status => :created, :location => @personal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @personal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /personals/1
  # PUT /personals/1.xml
  def update
    @personal = Personal.find(params[:id])

    respond_to do |format|
      if @personal.update_attributes(params[:personal])
        flash[:notice] = 'Personal was successfully updated.'
        format.html { redirect_to(@personal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @personal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /personals/1
  # DELETE /personals/1.xml
  def destroy
    @personal = Personal.find(params[:id])
    @personal.destroy

    respond_to do |format|
      format.html { redirect_to(personals_url) }
      format.xml  { head :ok }
    end
  end
end
