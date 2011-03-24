require 'openssl'
require 'socket'

class PersonalsafetiesController < ApplicationController
  before_filter :authorize
  skip_before_filter :verify_authenticity_token ,:only=>[:create]
  
  # GET /personalsafeties
  # GET /personalsafeties.xml
  def index
    @personalsafeties = Personalsafety.all


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @personalsafeties }
    end
  end

  # GET /personalsafeties/1
  # GET /personalsafeties/1.xml
  def show
    @personalsafety = Personalsafety.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @personalsafety }
    end
  end

  # GET /personalsafeties/new
  # GET /personalsafeties/new.xml
  def new
    @personalsafety = Personalsafety.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @personalsafety }
    end
  end

  # GET /personalsafeties/1/edit
  def edit
    @personalsafety = Personalsafety.find(params[:id])
  end

  # 安否情報登録
  # POST /personalsafeties
  # POST /personalsafeties.xml
  def create

    # ログ出力:
    logger.info("SCOPE2:安否情報登録:ユーザ=#{Personal.find(session[:personal_id]).full_name}::")


    # 安否情報のブロックを取得
    safeties = params[:safeties]
    if safeties.nil?
      safeties = params[:personalsafety]
    end
    # 共通情報取り出し
    group_id = safeties[:group_id]
    family_id = safeties[:family_id]
    # 個人の配列取得
    pids = safeties[:safety][:personal_id]
    pkds = safeties[:safety][:personal_safety_kind]
p "-----------"    
p pids
p pkds
    # トランザクション
    Personalsafety.transaction do
      # 現在の情報を一旦削除
      Personalsafety.delete_all(["family_id = ?", family_id])

# 実証実験の場合、1名だけなので暫定  
      psafety = Personalsafety.new()  # インスタンス生成
      psafety[:personal_id] = pids
      psafety[:group_id] = group_id
      psafety[:family_id] = family_id
      psafety[:personal_safety_kind] = pkds
      psafety.save                    # 登録  （エラー処理追加する）

# 本当はこちら
#      # 個人ごとに登録
#      i = 0 
#      while i < pids.size
#p "======="      
#        psafety = Personalsafety.new()  # インスタンス生成
#        psafety[:personal_id] = pids[i]
#        psafety[:group_id] = group_id
#        psafety[:family_id] = family_id
#        psafety[:personal_safety_kind] = pkds[i]
#p psafety        
#        psafety.save                    # 登録  （エラー処理追加する）
#        
#        i= i+1
#      end
    end

    respond_to do |format|
      format.html { render :action => "new" }
      format.xml { render :xml => '<safeties><results>OK</results></safeties>'}
    end

  # エラー処理
  rescue => ex
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => "<safeties><results>NG</results><message>#{ex.message}</message></safeties>"}
    end    
    
  end

  # PUT /personalsafeties/1
  # PUT /personalsafeties/1.xml
  def update
    @personalsafety = Personalsafety.find(params[:id])

    respond_to do |format|
      if @personalsafety.update_attributes(params[:personalsafety])
        flash[:notice] = 'Personalsafety was successfully updated.'
        format.html { redirect_to(@personalsafety) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @personalsafety.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /personalsafeties/1
  # DELETE /personalsafeties/1.xml
  def destroy
    @personalsafety = Personalsafety.find(params[:id])
    @personalsafety.destroy

    respond_to do |format|
      format.html { redirect_to(personalsafeties_url) }
      format.xml  { head :ok }
    end
  end
  
  # Push Notification
  def pushnotify

    # モード変更 (平常時 => 災害時)
    mode = Mode.find("1")
    mode.mode_kind = 1
    mode.save

    # ログ出力:
    logger.info("SCOPE2:災害情報通知(PushNotification):ユーザ=#{Personal.find(session[:personal_id]).full_name}::")

    # 該当のデバイス情報取得
    tokens = Devicetoken.find(:all)
    
    # Push送信
    pushNotify(tokens, "addalert")

    # レンダリング
    respond_to do |format|
      format.html { redirect_to(:controller => :logins, :action => :top) }
      format.xml  { head :ok }
    end
    
  end
  
end
