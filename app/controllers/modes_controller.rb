class ModesController < ApplicationController
  before_filter :authorize

  # GET /modes
  # GET /modes.xml
  def index
    @modes = Mode.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @modes }
    end
  end

  # GET /modes/1
  # GET /modes/1.xml
  def show
    @mode = Mode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mode }
    end
  end

  # GET /modes/new
  # GET /modes/new.xml
  def new
    @mode = Mode.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mode }
    end
  end

  # GET /modes/1/edit
  def edit
    @mode = Mode.find(params[:id])
  end

  # POST /modes
  # POST /modes.xml
  def create
    @mode = Mode.new(params[:mode])

    respond_to do |format|
      if @mode.save
        flash[:notice] = 'Mode was successfully created.'
        format.html { redirect_to(@mode) }
        format.xml  { render :xml => @mode, :status => :created, :location => @mode }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mode.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /modes/1
  # PUT /modes/1.xml
  def update
    @mode = Mode.find(params[:id])

    # ログ出力:
    logger.info("SCOPE2:災害モード変更:ユーザ=#{Personal.find(session[:personal_id]).full_name}::")
    
    # モード変更
    rtn = @mode.update_attributes(params[:mode])
    
    # デバイストークン取得
    tokens = Devicetoken.find(:all)
 
    # Push送信
    if params[:mode][:mode_kind] == "1"     # 災害モードに移行
      pushNotify(tokens, "changedisaster")
    else                                  # 平常時モードに移行
      pushNotify(tokens, "changenormal")
    end
    
    respond_to do |format|
      if rtn
        flash[:notice] = 'Mode was successfully updated.'
#        format.html { redirect_to(@mode) }
        format.html { redirect_to(:controller => :logins, :action => :top) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mode.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /modes/1
  # DELETE /modes/1.xml
  def destroy
    @mode = Mode.find(params[:id])
    @mode.destroy

    respond_to do |format|
      format.html { redirect_to(modes_url) }
      format.xml  { head :ok }
    end
  end
end
