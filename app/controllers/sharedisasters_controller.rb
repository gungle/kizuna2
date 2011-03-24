class SharedisastersController < ApplicationController
  
  def index
   
    # ログ出力:
    logger.info("SCOPE2:災害情報共有:ユーザ=#{Personal.find(session[:personal_id]).full_name}::")
   
    if ! params[:group_id].nil?
#    if ! params[:group_id].nil? && params[:group_id] == session[:group_id]
      # 組ID指定
      group = Group.find(params[:group_id]) # 該当組取得
      group.share_disaster_kind = 1         # 共有をON
      group.save                            # 保存

    else
      # パラメタエラー
      raise "parameter error"
    end

    # 該当のデバイス情報取得
    tokens = Devicetoken.find(:all, :conditions => ["personal_id <> ?", session[:personal_id]])
    
    # Push送信
    pushNotify(tokens, "sharedisaster")
    
    # レンダリング
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => '<sharedisasters><results>OK</results></sharedisasters>'}
    end

  # エラー処理
  rescue => ex
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => "<sharedisasters><results>NG</results><message>#{ex.message}</message></sharedisasters>"}
    end    
    
  end
  
end
