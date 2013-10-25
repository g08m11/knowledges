class Menu
=begin
  attr_accessor は自動で以下のメソッドを追加してくれます
  ActiveRecord使ってると暗黙的にできるけど
  本来は以下のようなaccessorとよばれるものを定義をしないといけないんだよ

  def name
    @name
  end

  def name=(name)
    @name = name
  end

=end
  attr_accessor :name, :price

  # メニューインスタンス取得用クラスメソッド
  # クラスメソッドはそのモデルのインスタンスを生成したり、取得したりする処理が書かれることが多い。
  # Model.find とかもそうだよね。
  def self.original
    #インスタンス生成
    # クラスメソッド内で用いるselfは、オブジェクトではなくクラスを指す
    # クラスメソッド内なので、self.newはMenu.newと同義ですね
    instance = self.new
    instance.name = 'Original Pizza'
    instance.price = '1000'
    return instance
  end

  # Seafood Pizza
  def self.seafood
    instance = self.new
    instance.name = 'Seafood Pizza'
    instance.price = '1500'
    return instance
  end

  def self.meat_lovers
    instance = self.new
    instance.name = 'Meat Lovers Pizza'
    instance.price = '1300'
    return instance
  end

end