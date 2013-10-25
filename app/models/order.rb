class Order
  # アクセッサ　内部のプライベート変数へのアクセスを提供するものです。
  #attr_accessorはdef menu  def menu=(menu)とかの省略記述だと思ってくださいね
  #rails4 だとこれもどこかに消えて見えなくなるけどね。
  attr_accessor :menu, :piece, :status

  #initialize はインスタンスが作成される際(newする時)に勝手に呼ばれます。
  #find とかでdbからとってくるときも実は裏で呼んでるんですよ〜　
  #すべてのインスタンスはこれが呼ばれてインスタンス化されます。
  #引数をつけるとnewする際に引数の指定が必要になる
  #java c#等ではコンストラクタと呼ばれ、特別なメソッドです。コンストラクタと言ったらこれのことを指すので
  #しっかり理解しましょう
  def initialize(menu, piece)
    # @ついてるのはプライベート変数　オブジェクト内部の変数
    # 上記のアクセッサによりアクセスが可能だからself.って書いてもオーケーね
    @menu = menu
    self.piece = piece
    # ステータスは最初だからnewってしとこう。
    self.status = 'new'
  end

  # これはインスタンスメソッド、自オブジェクトの状態によって返す値が変わる。
  # インスタンスメソッドの内部では自分自身のmenu, piece, statusへアクセスできる。
  def total_price
    # インスタンスメソッド内のselfは自分のオブジェクトを指す
    # selfは省略も可能　個人的にはあったほうが読みやすいので、率先してつけよう
    # to_iしないと文字連結になっちゃう
    self.menu.price.to_i * self.piece.to_i
  end

end

