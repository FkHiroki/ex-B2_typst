// タイトル

#align(center, text(18pt, "量子コンピューティング アニーリング レポート")) \

#align(right, text(12pt, "62217149 福原博樹"))

// = [A1-1]

//   $ E(s_1,s_2) = -J_(1,2) s_1 s_2 - h_1 s_1 - h_2 s_2, space s_i in {-1, 1} \
//     E_("QUBO") = a_1 x_1 + a_2 x_2 + b_(1,2) x_1 x_2 + "const", space x in {0, 1} \
//     x_i = (1 - s_i) / 2, space <=> space s_i = 1 - 2 x_i \ $
//   $ E(x_1,x_2) &= -J_(1,2) (1 - 2 x_1) (1 - 2 x_2) - h_1 (1 - 2 x_1) - h_2 (1 - 2 x_2) \
//     &= 2(J_(1,2) + h_1) x_1 + 2(J_(1,2) + h_2) x_2 - 4 J_(1,2) x_1 x_2 + "const" \
//     therefore a_1 &= 2(J_(1,2) + h_1), space a_2 = 2(J_(1,2) + h_2), space b_(1,2) = -4 J_(1,2) \ $

= [A2-2] 問題: 数独

  組合せ最適化問題として「数独」を選択した。アニーリングマシンを用いて数独を解くためのQUBO定式化について考える。
  数独の具体例として、2×2のブロックに区切られた4×4のマス目の数独を考える。各マス目には1から4までの数字が入る。この問題は、以下で考える制約条件を全て満たすものが解となるため、目的関数はない。まず、インデックス$i, j, k$がそれぞれ、マス目の行、列、数字を表すとする（各インデックスは$0~3$までとする）。この時、$x_(i,j,k)$は$0,1$のバイナリ変数で、マス目$(i,j)$に数字$k$が入る場合に$x_(i,j,k) = 1$となる。
  各マス目には1つの数字が入るため、次の制約が成り立つ。

  $ sum_(k=0)^3 x_(i,j,k) = 1, space forall i, j \ $

  次に、各列、行には同じ数字が入らないようにするための制約を考える。例えば、マス目$(0,0)$に数字$1$が入る場合、その列、行には数字$1$が入らないようにする必要がある。この制約は以下のように表される。

  $ sum_(i=0)^3 x_(i,j,k) = 1, space forall j, k \ 
    sum_(j=0)^3 x_(i,j,k) = 1, space forall i, k \ $
  
  最後に、各ブロックには同じ数字が入らないようにするための制約は以下のように表される。

  $ sum_(i,j in 2×2"ブロック") x_(i,j,k) = 1, space forall k \ $

  上記のように、全ての制約条件はOne-hot表現で表すことができた。これらの制約条件を満たすようなQUBO定式化を行うことで、数独を解くことができる。
  一般の問題規模での数独を解くためには、上記の制約条件を拡張すればよい。例えば、$n×n$のマス目に数字$1$から$n$までが入る数独の場合、インデックスは$0 space ~ space n-1$とするだけでよい。

= [A2-3]

  [A2-2]で求めた制約条件を入力して、数独をアニーリングマシンに解かせてみる。
  今回アニーリングマシンに以下の数独の問題を解かせる。

  #figure(
  image("../figs/sudoku_hardest.png", width: 50%),
  caption: "引用元: https://www.sentohsharyoga.com/ja/puzzle/blog/entry/sudoku_most_difficult",
  ) 

  制約条件をコードに落とし込むと以下のようになる。

  ```python
  from amplify import one_hot
  from amplify import sum as amplify_sum

  number_constraints = one_hot(q, axis=2) # 各マスには1つの数字が入る
  row_constraints = one_hot(q, axis=1) # 各行には1から9が1度ずつ
  column_constraints = one_hot(q, axis=0) # 各列には1から9が1度ずつ
  # 各ブロックには1から9が1度ずつ
  block_constraints = amplify_sum(
      one_hot(amplify_sum([q[i+m//3, j+m%3, k] for m in range(9)]))
      for i in range(0, 9, 3)
      for j in range(0, 9, 3)
      for k in range(9)
  # 全ての制約条件の和を取る
  constraints = number_constraints + row_constraints + column_constraints + block_constraints
  )

  ```
  そして、この制約条件を以下のようにアニーリングマシンに入力して解を求める。

  ```python
  from amplify import solve, FixstarsClient
  from datetime import timedelta

  client = FixstarsClient()
  client.token = "AE/6BC8Bfo4ZNBBvU10lhggLyPWQm2k1ZQB"
  client.parameters.timeout = timedelta(milliseconds=1000) # タイムアウト1秒

  result = solve(constraints, client=client)
  ```

  そして、以下に計算結果を盤面に表示させたものと、計算にかかった時間を示す。

  #figure(
  image("../figs/sudoku_result.png", width: 50%),
  ) 

  このように、$63 "ms"$で数独の問題を解くことができた。現在の古典コンピュータでは同じ問題を解く方法がいくつか見つかっている。例えば、Rust + WebAssemblyを用いて、今回のアニーリングマシンでの解法よりも高速に解くことができるようだ（参考：https://qiita.com/yuto-ono/items/3178d29ce5fc4e9eba02）。しかし、制約条件を整数・バイナリ変数で表現し、アニーリングマシンに入力することで、数独を解くことができることが確認できた。



