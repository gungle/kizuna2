class GroupsController < ApplicationController
  before_filter :authorize

  # GET /groups
  # GET /groups.xml
  def index

    # 初期化
    @result = Hash.new
    @result[:result] = "OK"
    @result[:message] = ""

    # ログ出力:
    logger.info("SCOPE2:組情報一覧:ユーザ=#{Personal.find(session[:personal_id]).full_name}::")

    # パラメタにより取得範囲を限定
    if ! params[:group_id].nil?
      # GroupID指定
      @groups = Group.find_all_by_id(params[:group_id])
    else    
      # その他
      @groups = Group.find(:all)
    end

    # その他の必要な情報を設定
    @groups.each{ |gr|
      gr[:family_number] = Family.count(:conditions => ["group_id = ?", gr.id])  # 組配下の世帯数を設定
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

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to(@group) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = 'Group was successfully updated.'
        format.html { redirect_to(@group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
end
