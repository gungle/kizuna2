# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # モード取得
  def getmode()
    mode = Mode.find(:first)
    a = mode[:mode_kind]
  end

  # API復帰値
  def getresultcode(a)
    # 現状、値が変わらいけど、今後リザルトコードの変更に対応するためメソッド化
    case a
    when "OK"
      "OK"
    else
      "NG"
    end
  end
  
  # 年齢
  def age(a)
    Date.today.year - a.year
  end

  # コードから値を返す汎用メソッド　=========================================
  def getValByCode(arrs, a)
    r = ""
    arrs.each{ |ary|
     r = ary[0] if ary[1] == a
    }
    r
  end

  # 安否確認種別のコード表
  def getsafetykind
    [["大丈夫", 1],["ケガ、不明者など", 2]]
  end
  
  # 性別のコード表
  def getsexkind
    [["男", 1],["女", 2]]
  end

  # 血液型のコード表
  def getbloodkind
    [["A", 1],["B", 2],["O", 3],["AB", 4],["その他", 5]]
  end

  # 災害弱者のコード表
  def getweakkind
    [["非弱者", 0],["災害弱者", 1]]
  end

  # 位置情報のコード表
  def getplacekind
    [["人（通常）", 11],["人（災害弱者）", 12],["人（被災者）", 13],["家", 14],["避難場所", 15],["病院", 16],["災害箇所", 17]]
  end

  # 緊急度のコード表
  def getemergencykind
    [["設定なし", 0],["緊急度小", 1],["緊急度中", 2],["緊急度大", 3]]
  end

  # 災害状況のコード表
  def getdisasterkind
    [["設定なし", 0],["行方不明", 1],["大ケガ", 2],["閉じ込め", 3],["タンスの下敷き", 4],["意識不明", 5]]
  end

  # トリアージのコード表
  def gettriagekind
    [["設定なし", 0],["緑", 1],["黄", 2],["赤", 3],["黒", 4]]
  end

  # 対応有無のコード表
  def getdonekind
    [["未対応", 0],["対処済み", 1]]
  end

end
