class DevicetokensController < ApplicationController
#  before_filter :authorize
  skip_before_filter :verify_authenticity_token

  # GET /devicetokens
  # GET /devicetokens.xml
  def index
    @devicetokens = Devicetoken.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @devicetokens }
    end
  end

  # GET /devicetokens/1
  # GET /devicetokens/1.xml
  def show
    @devicetoken = Devicetoken.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @devicetoken }
    end
  end

  # GET /devicetokens/new
  # GET /devicetokens/new.xml
  def new
    @devicetoken = Devicetoken.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @devicetoken }
    end
  end

  # GET /devicetokens/1/edit
  def edit
    @devicetoken = Devicetoken.find(params[:id])
  end

  # POST /devicetokens
  # POST /devicetokens.xml
  def create

    # ログ出力:
    logger.info("SCOPE2:デバイストークン登録:ユーザ=#{Personal.find(params[:devicetoken][:personal_id]).full_name}:デバイストークン#{params[:devicetoken]}:")

    # 現在の情報を一旦削除
    Devicetoken.delete_all(["personal_id = ?", params[:devicetoken][:personal_id]])

    @devicetoken = Devicetoken.new(params[:devicetoken])

    respond_to do |format|
      if @devicetoken.save
        flash[:notice] = 'Devicetoken was successfully created.'
        format.html { redirect_to(@devicetoken) }
        format.xml { render :xml => '<devicetoken><results>OK</results></devicetoken>'}
      else
        format.html { render :action => "new" }
        format.xml { render :xml => '<devicetoken><results>NG</results></devicetoken>'}
      end
    end
  end

  # PUT /devicetokens/1
  # PUT /devicetokens/1.xml
  def update
    @devicetoken = Devicetoken.find(params[:id])

    respond_to do |format|
      if @devicetoken.update_attributes(params[:devicetoken])
        flash[:notice] = 'Devicetoken was successfully updated.'
        format.html { redirect_to(@devicetoken) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @devicetoken.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /devicetokens/1
  # DELETE /devicetokens/1.xml
  def destroy
    @devicetoken = Devicetoken.find(params[:id])
    @devicetoken.destroy

    respond_to do |format|
      format.html { redirect_to(devicetokens_url) }
      format.xml  { head :ok }
    end
  end
end
