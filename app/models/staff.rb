=begin
学習方法
bundle exec rails c でコンソールを起動する
①とりあえずstaffをインスタンス化する
staff = Staff.new

②オーダー取得（複数回可能)
staff.get_call

③調理（１回で溜まってるオーダー全部調理可能）
staff.cook

④配達(１回につき古いオーダーから１個配達する、金額が表示される、複数回可能)
staff.deliver

上記処理を数回繰り返し
出力される挙動を把握する。
orderのstatusの変化（new➡cooked➡delivered)
pizzas配列 deliver すると消える
配達後の金額　order 毎に変わる　などなど

staff.rb
menu.rb
order.rb
pizza.rb

のソースコードを本気で読む
この４つのファイルだけでいいです。
以上にてクラスメソッド、インスタンスメソッド
の理解ができるハズ

言葉の定義
　インスタンス：オブジェクトと同義です。newしたクラスの事をさします。
　　　　　　　　暗黙的にnewされてることもあるので気をつけてね というかそれがほとんど
　　　　　　　　内部にローカル変数や値を保持することができる。

　クラスメソッド：静的メソッドとも呼ばれる
　　　　　　　　　def self.hoge みたいに定義する、他にも定義方法はあるけど・・・
　　　　　　　　　呼ぶ時は Class.hoge　
　　　　　　　　　Module内部に定義されているクラスならば
　　　　　　　　　Module::Class.hoge

　インスタンスメソッド：動的メソッドとも呼ばれる？
　　　　　　　　　インスタンスがもつメソッド、インスタンスの内部変数等に
　　　　　　　　　よって挙動がかわる。
　　　　　　　　　def hoge と定義する
　　　　　　　　　呼ぶ時は当然インスタンスがなければいけない。
　　　　　　　　　instance = Class.new instanceを取得する方法は他にもいろいろある
　　　　　　　　　instance = Class.find(id) とかもインスタンス取得に日々使っている。内部でnewが呼ばれている。
　　　　　　　　　instance.hoge
　オブジェクト指向
　　　　　　　　データ（オブジェクト）に対して振る舞い(メソッド)を持たせる考え方。
　　　　　　　　オブジェクトを集めてシステムを構築する感じ
　　　　　　　　継承、カプセル化、ポリモルフィズム等の概念が存在する。ここはちょっと次回乞うご期待
　　　　　　　　データ自体にメソッドを持たせることで、
　　　　　　　　パラメータで引数を渡す記述が減って、より直感的にコードを記述することができる
　　　　　　　　理解しないでruby on rails記述するとめちゃめちゃなソースコードになる。
=end

class Staff
  # 複数形　単数形のきりわけはしっかりしようね
  attr_accessor :orders, :pizzas

  def initialize
    # 初期値の空配列入れとかないと << した時にno method errorだね。
    # initialize の中では自オブジェクトの初期化処理を入れる事があります。
    self.orders = []
    self.pizzas = []
  end

  # オーダーの取得メソッド　ランダムでメニューと数量が入ります
  def get_call
    # randメソッドは0から始まるランダム数値を返します
    menu_no = rand(3) + 1 #1 or 2 or 3
    piece = rand(5) + 1 #1 or 2 or 3 or 4 or 5

    case menu_no
      when 1
        # クラスメソッド呼び出しはクラス名.メソッド名
        menu = Menu.original
      when 2
        menu = Menu.seafood
      when 3
        menu = Menu.meat_lovers
      else
        return 'wrong menu no !!!'
    end
    # newはコンストラクタを呼び出す。initializeに引数があるばあい、引数をとる。 << は配列への追加
    @orders << Order.new(menu, piece)

    # console で見やすいようにstaffの状態ををJSONに出力するよ
    puts JSON.pretty_generate(JSON.parse(self.to_json))
  end

  # orderからpizzaのインスタンスをつくって、orderの状態をcookedにする
  # 全オーダー分のピザを一気につくる
  def cook
    # selectで新規オーダーだけを対象にするよ、今回ActiveRecord使ってないから、find_byとかwhereとかは使えないよ
    new_orders = self.orders.select { |order| order.status == 'new'}
    if new_orders.blank?
      return 'no new orders !!!'
    end

    new_orders.each do |order|
      # 枚数分のピザを作ってストックするよ
      order.piece.times do
        @pizzas << Pizza.new(order.menu.name)
      end
      # オーダーのステータスを調理済みにする
      order.status = 'cooked'
    end

    puts JSON.pretty_generate(JSON.parse(self.to_json))
  end

  # cooked の状態のorderを一つ取り出して、金額を算出
  # 1回呼び出しにつき1オーダー分配達する
  # orderのステータスをdeliveredに更新する
  def deliver
    #調理済みオーダーの取得
    cooked_orders = self.orders.select {|order| order.status == 'cooked'}
    if cooked_orders.blank?
      return 'no cooked orders.'
    end

    #一番古いオーダーを取得する
    order = cooked_orders[0]

    # ピザをorderの枚数分消費する
    # pizza作る順番と消費する順が一致してるから一応これでok
    # 本当はorderとpizzaをキチンと関連つけて消したほうがいい
    order.piece.times do
      # 配列の先頭のインスタンスを抹消してます。
      self.pizzas.delete_at(0)
    end

    order.status = 'delivered'

    puts JSON.pretty_generate(JSON.parse(self.to_json))
    # total_priceっていうインスタンスメソッドを呼ぶ
    # インスタンスメソッドはインスタンスの状態に依存する処理を行う
    #
    puts "PRICE #{order.total_price} JPY."
  end

  # こういう奴をクラスメソッドにする
  # 個別のスタッフオブジェクトに依存しないスタッフ関連の処理
  # 平均年齢の取得　とかね。
  def self.get_average_age
    return 30
  end

end

