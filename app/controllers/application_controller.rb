# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  # 認証処理 loginを通過していない処理はエラーとする
  def authorize
    unless session[:group_id]
#      render :xml => '<login><results>NG</results><message>you must login.</message></login>'
    end
  end
  
  # PushNotificationの処理
  def pushNotify(tokens, mess)

    case mess
    when "changenormal"
      payload = <<-EOS
      {
        "aps":{
         "alertMode":1,
         "modeKind":0,
         "alert":"通常状態に戻りました",
         "sound":"default"
        }
      }
EOS
    when "changedisaster"
      payload = <<-EOS
      {
        "aps":{
         "alertMode":1,
         "modeKind":1,
         "alert":"地震が発生しました",
         "sound":"default"
        }
      }
EOS
    when "addalert"
      payload = <<-EOS
      {
        "aps":{
         "alertMode":0,
         "modeKind":1,
         "alert":"行政からの災害情報のお知らせ",
         "sound":"default"
        }
      }
EOS

    when "sharedisaster"
      payload = <<-EOS
      {
        "aps":{
         "alertMode":1,
         "modeKind":1,
         "alert":"他組の被害情報を受信しました",
         "sound":"default"
        }
      }
EOS
    end

    tokens.each{|token|

      # デバイストークン取得
      device = [token[:device_token]]

   
      # APNsへのソケット作成
      socket = TCPSocket.new('gateway.sandbox.push.apple.com',2195)
   
      # SSL通信の下準備
      context = OpenSSL::SSL::SSLContext.new('SSLv3')
      ### 証明書の読み込み
      path = RAILS_ROOT + PATH_CERT_CERT
      context.cert = OpenSSL::X509::Certificate.new(File.read(path))
      ### keyの読み込み
      path = RAILS_ROOT + PATH_CERT_KEY
      context.key  = OpenSSL::PKey::RSA.new(File.read(path))
      
      # SSLでソケット作成、コネクト
      ssl = OpenSSL::SSL::SSLSocket.new(socket, context)
      ssl.connect
   
      # 送信フォーマット整形
      (message = []) << ['0'].pack('H') << [32].pack('n') << device.pack('H*') << [payload.size].pack('n') << payload
   
      # 送信！
      ssl.write(message.join(''))
      
      # ソケットクローズ
      ssl.close
      socket.close
    }
   
  end
 
end
