class LoginsController < ApplicationController
  layout "standard", :except => [:xml]

  # GET /logins
  # GET /logins.xml
  def index


    # パラメータの確認
    if !params[:login].nil? && !params[:password].nil?    
       @login = Personal.find_by_login_and_password(params[:login], params[:password])
    elsif !params[:logins].nil? && !params[:logins][:login].nil? && !params[:logins][:password].nil?    
       @login = Personal.find_by_login_and_password(params[:logins][:login], params[:logins][:password])
    end

    if !@login.nil?
       # 該当ユーザが存在する
       @login[:result] = "OK"
       
       # 以下の情報をセッションに格納
       session[:group_id] = @login[:group_id]
       session[:family_id] = @login[:family_id]
       session[:personal_id] = @login[:id]
  
      # ログ出力:
      logger.info("SCOPE2:ログイン処理:ユーザ=#{Personal.find(session[:personal_id]).full_name}:OK:")
      
    else
       # 該当ユーザが存在しない
       @login = Personal.new
       @login[:result] = "NG"
       @login[:message] = "user not found."

       # 以下の情報をセッションに格納
       session[:group_id] = nil
       session[:family_id] = nil
       session[:personal_id] = nil

      # ログ出力:
      logger.info("SCOPE2:ログイン処理::NG:")
        
    end
    
    # レンダリング
    respond_to do |format|
      if @login[:result] == "OK"
        flash[:result] = "login ok."
        format.html { redirect_to(:action => :top) }
        format.xml  { render :layout=>false}
      else
        flash[:result] = "login ng."
        format.html { redirect_to("/login") }
        format.xml  { render :layout=>false}
      end
    end
    
  end

  # PC用のログイン画面を表示
  def loginpc
  
    # レンダリング
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # トップ画面表示
  def top
    # 災害モードを取得
    @mode = Mode.find(:first)
    # アクセス制御モードを取得
    @access = Access.find(:first)

    # レンダリング
    respond_to do |format|
      format.html # index.html.erb
    end
  end


end
