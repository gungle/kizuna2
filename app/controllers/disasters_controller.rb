class DisastersController < ApplicationController
  before_filter :authorize
  skip_before_filter :verify_authenticity_token

  # GET /disasters
  # GET /disasters.xml
  def index

    # 初期化
    @result = Hash.new
    @result[:result] = "OK"
    @result[:message] = ""

    if  ! params[:pc].nil?              # PC用
      @disasters = Disaster.all
    
    elsif ! params[:personal_id].nil?
      @result[:viewkind] = "detail"     # Viewの表示種別(詳細)

      # ログ出力:
      logger.info("SCOPE2:災害情報詳細:ユーザ=#{Personal.find(session[:personal_id]).full_name}::")

      # 災害情報詳細
      @disasters = Disaster.find_all_by_personal_id(params[:personal_id])
      if @disasters.empty?
        @result[:result] = "NG"
        @result[:message] = "can't find personal(disaster)"
      else
        # その他の必要な情報を設定
        @disasters.each do |ds|
          personal = Personal.find(ds[:personal_id])  # 個人情報を取得
          ds[:full_name] = personal.full_name
          ds[:blood] = personal.blood
          ds[:sex] = personal.sex
          ds[:birthday] = personal.birthday
        end
      end
      
    else
      @result[:viewkind] = "list"     # Viewの表示種別(一覧)

      # ログ出力:
      logger.info("SCOPE2:災害情報:ユーザ=#{Personal.find(session[:personal_id]).full_name}::")

      # 自分の組と閲覧許可の組だけ情報取得
      groups = Group.find(:all, :conditions => ["id = ? or share_disaster_kind = 1", session[:group_id]]) # 複数件
#     groups = Group.all
      
      # グループごとに情報収集
      groups.each{|group|
      
        # 安否情報
        families = Family.find_all_by_group_id(group.id)    # 組内の家族一覧を取得
        families.each{|family|
          pss = Personalsafety.find(:all, :conditions => ["family_id = ?", family.id]) # 複数件
#         pss = Personalsafety.find(:all, :conditions => ["family_id = ? and personal_safety_kind = 2", family.id]) # 複数件
#         pss = Personalsafety.find_by_family_id(family.id) # 安否報告テーブルをチェック

# 家族単位で、、、
# 安否報告なし　　　　　　　安否報告なしを出力する 
# 安否報告あり 全員OK  　 出力しない
# 安否報告あり 一人でもNG  該当者を出力する

          if pss.empty?                                     # 安否報告なし
            family[:report] = 0                             # 報告なしフラグ

            family[:status] = "0"                           # 状況を設定(家族報告なし)
          else                                              # 安否報告あり
            family[:report] = 1                             # 報告ありフラグ
          
            pss.each{ |ps|                                  # 人数分設定
              person = Personal.find(ps.personal_id)        # 個人情報取得
             
              ps[:full_name] = person.full_name
              ps[:birthday] = person.birthday
              ps[:sex] = person.sex
#              ps[:personal_id] = person.id
#              ps[:personal_safety_kind] = pss.personal_safety_kind
            }
            family[:persons] = pss
            
          end
        }
        
        group[:safeties] = families

        # 被災情報
        disasters = Disaster.find_all_by_group_id(group.id)
        disasters.each{|dis|
          person = Personal.find(dis.personal_id)
          dis[:full_name] = person.full_name
          dis[:birthday] = person.birthday
          dis[:sex] = person.sex
        }
        group[:disas] = disasters
        
        # 災害弱者情報取得
        weaks = Personal.find(:all, :conditions => ["group_id = ? and weak_kind = 1", group.id])
        weaks.each{|weak|
          dis = Disaster.find_by_personal_id(weak.id)
          weak[:done_kind] = dis.nil? ? 0 : dis.done_kind
        }
# =======
        # 被災者情報と災害弱者情報で重複する人がいる場合、災害弱者情報の方を削除する
        disasters.each{|dis|
          cnt = 0;
          weaks.each{|weak|
            if dis.personal_id == weak.id 
              weaks.delete_at(cnt);
            end
            cnt = cnt +1 ;
          }
        }
# =======        
        group[:weaks] = weaks
      }
      
      # 災害情報一覧
      @disasters = groups
    end

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

  # GET /disasters/1
  # GET /disasters/1.xml
  def show
    @disaster = Disaster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @disaster }
    end
  end

  # GET /disasters/new
  # GET /disasters/new.xml
  def new
    @disaster = Disaster.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @disaster }
    end
  end

  # GET /disasters/1/edit
  def edit
    @disaster = Disaster.find(params[:id])
  end

  # POST /disasters
  # POST /disasters.xml
  def create

    if  ! params[:pc].nil?              # PC用
      @disaster = Disaster.new(params[:disaster])
      
    else                                # REST用
      done_kind = 0
      triage_kind = 0
      old = Disaster.find_by_personal_id(params[:disaster][:personal_id])
      if !old.nil?
          done_kind = old[:done_kind]
          triage_kind = old[:triage_kind]
      end

      # ログ出力:
      logger.info("SCOPE2:災害情報登録:ユーザ=#{Personal.find(session[:personal_id]).full_name}::")   
  
      # 現在の情報を一旦削除
      Disaster.delete_all(["personal_id = ?", params[:disaster][:personal_id]])
  
      # 登録用のインスタンス生成
      @disaster = Disaster.new(params[:disaster])
      # デフォルト値を設定
      @disaster[:group_id] = Personal.find(params[:disaster][:personal_id])[:group_id]
      @disaster[:done_kind] = done_kind
      @disaster[:triage_kind] = triage_kind

    end

    respond_to do |format|
      if @disaster.save
        flash[:notice] = 'Disaster was successfully created.'
        format.html { redirect_to(@disaster) }
        format.xml { render :xml => '<disaster><results>OK</results></disaster>' }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => "<disaster><results>NG</results><message>can't create disaster</message></disaster>" }
      end
    end
    
  # エラー処理
  rescue => ex
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => "<disaster><results>NG</results><message>#{ex.message}</message></disaster>"}
    end    
    
  end

  # PUT /disasters/1
  # PUT /disasters/1.xml
  def update

    if  ! params[:pc].nil?              # PC用
      @disaster = Disaster.find(params[:id])
    else
      # 該当データ取得
      @disaster = Disaster.find_by_personal_id(params[:id])
    end  

      # ログ出力:
      logger.info("SCOPE2:災害情報登録:ユーザ=#{Personal.find(session[:personal_id]).full_name}::")

    respond_to do |format|
      if @disaster.update_attributes(params[:disaster]) # 該当項目のみ更新
        flash[:notice] = 'Disaster was successfully updated.'
        format.html { redirect_to(@disaster) }
        format.xml { render :xml => '<disaster><results>OK</results></disaster>' }

      else
        format.html { render :action => "edit" }
        format.xml { render :xml => "<disaster><results>NG</results><message>can't update disaster</message></disaster>" }

      end
    end
    
  # エラー処理
  rescue => ex
    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => "<disaster><results>NG</results><message>#{ex.message}</message></disaster>"}
    end    
  end

  # DELETE /disasters/1
  # DELETE /disasters/1.xml
  def destroy
    @disaster = Disaster.find(params[:id])
    @disaster.destroy

    respond_to do |format|
      format.html { redirect_to(disasters_url) }
      format.xml  { head :ok }
    end
  end
end
