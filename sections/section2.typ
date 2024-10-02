#import "@preview/physica:0.9.2": *

// タイトル

#align(center, text(18pt, "量子コンピューティング ゲート方式 レポート")) \

#align(right, text(12pt, "62217149 福原博樹"))

= 問G3.2

  $R_x(theta), R_y(theta), R_z(theta)$ の3つの回転ゲートの効果を確認した。今回は、$theta = pi/4$とした。
  $ket(0)$ に対して、$R_x (pi/4)$、$ket(+)$に対して、$R_y (pi/4)$、$R_z (pi/4)$を作用させた。以下に、作用させる前と後のBloch球の画像を示す。


  #grid(
    columns: 2,//列数
    [#figure(
        image("../figs/bloch_sphere_0.png", width: 70%),//画像のパス
        caption: [$ket(0)$],
    )<glacier>],//コードブロックで囲む
    [#figure(
        image("../figs/bloch_sphere_0_rx.png", width: 70%),//画像のパス
        caption: [$R_x (pi/4)ket(0)$],
    )<magma>],
  )

  #grid(
      columns: 3,//列数
      [#figure(
          image("../figs/bloch_sphere_h.png",),//画像のパス
          caption: [$ket(+)$],
      )<glacier>],//コードブロックで囲む
      [#figure(
          image("../figs/bloch_sphere_h_ry.png", ),
          caption: [$R_y (pi/4)ket(+)$],
      )<magma>],
      [#figure(
          image("../figs/bloch_sphere_h_rz.png", ),
          caption: [$R_z (pi/4)ket(+)$],
      )<magma>],
  )\
= 問G3.4 

== (1)

  以下に、作成した量子回路とその実行結果を示す。
  以下の画像より、量子回路が2進数の加算$1 + 1 = 2$を行っていることがわかる。

  #grid(
    columns: 2,//列数
    [#figure(
        image("../figs/qc_3.4.png"),//画像のパス
        caption: [量子回路 $1+1$],
    )<glacier>],//コードブロックで囲む
    [#figure(
        image("../figs/qc_3.4_result.png"),//画像のパス
        caption: [実行結果 $1+1$],
    )<magma>],
  )

== (2)

  以下に、$1 + 0 = 1$、$0 + 1 = 1$、$0 + 0 = 0$の3つの量子回路とその実行結果を示す。確かに、全ての2ビットの加算が正しく行われていることがわかる。

  #grid(
    columns: 2,//列数
    [#figure(
        image("../figs/qc_10.png"),//画像のパス
        caption: [量子回路 $1+0$],
    )<glacier>],//コードブロックで囲む
    [#figure(
        image("../figs/qc_10_result.png"),//画像のパス
        caption: [実行結果 $1+0$],
    )<magma>],
    [#figure(
        image("../figs/qc_01.png"),//画像のパス
        caption: [量子回路 $0+1$],
    )<glacier>],
    [#figure(
        image("../figs/qc_01_result.png"),//画像のパス
        caption: [実行結果 $0+1$],
    )<magma>],
    [#figure(
        image("../figs/qc_00.png"),//画像のパス
        caption: [量子回路 $0+0$],
    )<glacier>],
    [#figure(
        image("../figs/qc_00_result.png"),//画像のパス
        caption: [実行結果 $0+0$],
    )<magma>],
  )



= 問G3.5

  以下のコードからベル状態$1/sqrt(2) (ket(01) + ket(10))$を作る量子回路を作成した。

  ```python
  # ２量子ビット回路を作成
  qc = QuantumCircuit(2)
  # Hゲートを0番目の量子ビットに
  qc.h(0)
  # Xゲートを1番目の量子ビットに
  qc.x(1)
  # CNOTを0,1番目の量子ビットに
  qc.cx(0,1)
  # 回路を描画
  qc.draw(output="mpl")
  ```
  以下に、作成した量子回路の図と、状態ベクトルシミュレータを用いた結果を示す。

  #grid(
    columns: 1,//列数
    [#figure(
        image("../figs/qc_3.5.png"),//画像のパス
        caption: [量子回路],
    )<glacier>],//コードブロックで囲む
    [#figure(
        image("../figs/qc_3.5_result.png"),//画像のパス
        caption: [状態ベクトルシミュレータの結果],
    )<magma>],
  )


= 問G3.7

  理論的には、以下のようになるはずである。

  $ "Controlled-T" ket(0+) &= "Controlled-T" 1/sqrt(2) ket(0) (ket(0) + ket(1)) \
    &= "Controlled-T" 1/sqrt(2) (ket(00) + ket(01)) \
    &= 1/sqrt(2) (ket(00) + ket(01)) \
    &= 1/sqrt(2) ket(0+) $

  よって、制御量子ビット$q_0$は$ket(+)$になる。 \
  これを確認するために、以下のコードを実行した。

  ```python
  from qiskit import QuantumCircuit
  from qiskit.circuit.library import U1Gate
  import numpy as np

  # 量子回路の作成
  qc = QuantumCircuit(2)

  # 2制御U1ゲートの作成
  c2u1_gate = U1Gate(np.pi/4).control(1)

  # アダマールゲートをq_0に作用
  qc.h(0)

  # 制御U1ゲートを量子回路に追加
  qc.append(c2u1_gate, [0, 1])

  # 回路を描画


  qc.draw(output="mpl")
  ```
  \

  以下に、作成した量子回路の図と、状態ベクトルシミュレータを用いた結果を示す。

  #grid(
    columns: 1,//列数
    [#figure(
        image("../figs/qc_3.7.png"),//画像のパス
        caption: [量子回路],
    )<glacier>],//コードブロックで囲む
    [#figure(
        image("../figs/qc_3.7_result.png"),//画像のパス
        caption: [状態ベクトルシミュレータの結果],
    )<magma>],
  )

= 問G4.1 

  以下では第１レジスタのみに注目する。

  $ ket(psi_1) &= 1 / sqrt(2^3) sum_(x=0)^(2^3-1) ket(x) \
    ket(psi_2) &= 1 / sqrt(8) sum_(x=0)^(7) (-1)^(f(x)) ket(x) \
    ket(psi_3) &= H^(⊗3) ket(psi_2) = 1 / sqrt(8) sum_(x=0)^(7) (-1)^(f(x)) H^(⊗3) ket(x) $

  ここで、$ket(x) = ket(x_0) ket(x_1) ket(x_2)$とすると、

    $ H^(⊗3) ket(x) = H ket(x_0) H ket(x_1) H ket(x_2) $

    $ket(y) = ket(y_0) ket(y_1) ket(y_2)$を、$H^(⊗3) ket(x)$から得られる状態の一つであるとする。
    この時、$ket(y)$の符号が正か負かを判別する方法を考える。まず、$ket(y_0)$に着目する。$ket(y_0)$は、$H ket(x_0)$の値によって、以下のように決まる。

    #figure(
    table(
    columns: 3,
    stroke: (none),
    table.header(
      $ket(x_0)$,
      $H ket(x_0)$,
      $ket(y_0)$,
    ),
    table.hline(),
    $ket(0)$, $1/sqrt(2) (ket(0) + ket(1))$, $ket(0) "or" ket(1)$,
    $ket(1)$, $1/sqrt(2) (ket(0) - ket(1))$, $ket(0) "or" -ket(1)$,
    table.hline(),
    )
    ) <tab:>

    上の表から、$ket(y_0)$の符号は、$(-1)^(x_0 dot y_0)$で表されることがわかる。
    同様の考え方から、$ket(y_1)$、$ket(y_2)$の符号はそれぞれ$(-1)^(x_1 dot y_1)$、$(-1)^(x_2 dot y_2)$で表される。$ket(y) = ket(y_0) ket(y_1) ket(y_2)$より、$ket(y)$の符号は$(-1)^(x_0 dot y_0 + x_1 dot y_1 + x_2 dot y_2)$で表される。ここで、$ket(y)$の符号を決めるのに重要なのは、$x_0 dot y_0 + x_1 dot y_1 + x_2 dot y_2$の値が偶数か奇数かであるため、この式を、

    $ x_0 dot y_0 plus.circle x_1 dot y_1 plus.circle x_2 dot y_2 eq.triple x dot y $

    と表現すれば良いとわかる。以上より、$H^(⊗3) ket(x)$は、

    $ H^(⊗3) ket(x) = 1 / sqrt(8)sum_(y=0)^(7) (-1)^(x_0 dot y_0 plus.circle x_1 dot y_1 plus.circle x_2 dot y_2) ket(y) = 1 / sqrt(8) sum_(y=0)^(7) (-1)^(x dot y) ket(y) $

    と表される。よって、$ket(psi_3)$は、

    $ ket(psi_3) &= 1 / sqrt(8) sum_(y=0)^(7) (-1)^(f(x)) [1 / sqrt(8) sum_(x=0)^(7) (-1)^(x dot y)] ket(y) \
      &= 1 / 8 sum_(x=0)^(7) [sum_(y=0)^(7) (-1)^{f(x) + x dot y}] ket(y) \
      &= 1 / 8 sum_(y=0)^(7) [sum_(x=0)^(7) (-1)^(f(x)) (-1)^(x dot y)] ket(y) $

    と表されることが確認できた。\
    これを一般の$n$ビットに拡張する。$ket(y) = ket(y_0) ket(y_1) dots ket(y_k) dots ket(y_(n-1))$とする。この時、$ket(y_k)$の符号は、$(-1)^(x_k dot y_k)$で表される。よって、$ket(y)$の符号は$(-1)^(x_0 dot y_0 + x_1 dot y_1 + dots + x_(n-1) dot y_(n-1)) eq.triple x dot y$で表される。
    一般の$n$ビットに拡張した時、

    $ ket(psi_2) &= 1 / sqrt(2^n) sum_(x=0)^(2^n-1) (-1)^(f(x)) ket(x) \
      ket(psi_3) &= H^(⊗n) ket(psi_2) = 1 / sqrt(2^n) sum_(x=0)^(2^n-1) (-1)^(f(x)) H^(⊗n) ket(x) \
      &= 1 / sqrt(2^n) sum_(x=0)^(2^n-1) (-1)^(f(x)) [1 / sqrt(2^n) sum_(y=0)^(2^n-1) (-1)^(x dot y)] ket(y) \
      &= 1 / 2^n sum_(y=0)^(2^n-1) [sum_(x=0)^(2^n-1) (-1)^(f(x)) (-1)^(x dot y)] ket(y) $

    と表されることがわかる。

= 問G4.2

  #figure(
  image("../figs/g4.2.png", width: 90%),
  ) <fig:>

  今回の問題の分布と問題の上にある分布を見比べると、010と110の結果を反転したものとなっていることがわかる。
  010と110はどちらも$q_1q_0$が10となっているため、$q_1q_0$が10の場合に$q_3$を反転させる部分を問題文の上の回路に追加すれば良いことがわかる。追加した回路は以下のようになる。

  #figure(
  image("../figs/qc_g4.2.png", width: 90%),
  ) <fig:>

  この回路を実行した結果を以下に示す。

  #figure(
  image("../figs/qc_g4.2_result.png", width: 90%),
  ) <fig:>

  よって、与えられた分布と一致していることがわかる。\
  以下にコードを示す。

  ```python
  from qiskit import QuantumCircuit
  from qiskit_aer import StatevectorSimulator, AerSimulator
  from qiskit_ibm_runtime import SamplerV2 as Sampler
  from qiskit.visualization import plot_histogram
  import matplotlib.pyplot as plt
  from collections import Counter
    qc = QuantumCircuit(4,1)

  # ゲートを適用
  qc.x(1)
  qc.barrier()
  qc.cx(0,3)
  qc.cx(1,3)
  qc.cx(2,3)
  qc.barrier()
  qc.x(1)
  qc.barrier()
  qc.x(0)
  qc.ccx(0,1,3)
  qc.x(0)
  qc.barrier()

  # 測定ゲートを追加
  qc.measure(3, 0)

  # 回路を描画
  qc.draw(output="mpl", style = "clifford")

  # シミュレーターを用いて実行
  for i in range(8):
    # 初期状態を設定
    initial_state = format(i, '03b')  # 3ビットの2進数表記
    initial_qc = QuantumCircuit(4, 1)
    
    for idx, bit in enumerate(initial_state):
        if bit == '1':
            if idx == 0 :
                initial_qc.x(idx+2)
            if idx == 1:
                initial_qc.x(idx)
            if idx == 2:
                initial_qc.x(idx-2)
    
    # 初期状態を設定した量子回路に対してゲートを適用
    total_qc = initial_qc.compose(qc)

    # 初期状態を設定した量子回路に対してゲートを適用
    total_qc = initial_qc.compose(qc)
    # Samplerで実行
    backend = AerSimulator()
    sampler = Sampler(backend)
    job = sampler.run([total_qc])
    result = job.result()
    
    #  測定された回数を表示
    counts = result[0].data.c.get_counts()
    print(f" > Imputs: {initial_state}, Counts: {counts}")
  ```

= 問G4.3

  回路図と、コードを以下に示す。

  #figure(
  image("../figs/qc_g4.3.png", width: 90%),
  ) <fig:>

  ```python
  from qiskit import QuantumCircuit
    qc = QuantumCircuit(11,10)

    # ゲートを適用
    qc.x(10)
    for i in range(11):
        qc.h(i)

    qc.barrier()
    qc.cx(0,10)
    qc.id(1)
    qc.cx(2,10)
    qc.id(3)
    qc.id(6)
    qc.cx(4,10)
    qc.cx(5,10)
    qc.cx(7,10)
    qc.cx(8,10)
    qc.cx(9,10)
    qc.barrier()

    for i in range(10):
        qc.h(i)
        

    # 測定ゲートを追加
    for i in range(10):
        qc.measure(i, i)

    # 回路を描画
    qc.draw(output="mpl", style = "clifford")
  ```

  回路図の一番右のブロックでは、$q_0$から$q_9$までのビット($ket(x)$)を$ket(+)$にし、$q_(10)$を$ket(-)$にしている。次に真ん中のブロックで、$ket(x)$と$s$の内積を計算し、$q_(10)$に格納している。この時、phase kick backにより、$s$と$ket(x)$の内積がレジスタビットに表れる。最後に一番左のブロックで、$ket(x)$にアダマールゲートを通すことで、$s$が得られるようになる。

  コードのシミュレーション結果とそのコードを以下に示す。以下により、$s$が得られていることがわかる。

  #figure(
  image("../figs/qc_g4.3_result.png", width: 90%),
  ) <fig:>

  ```python
  from qiskit.transpiler.preset_passmanagers import generate_preset_pass_manager
  from qiskit_ibm_runtime import SamplerV2 as Sampler

  # シミュレーターで実験
  backend = AerSimulator()
  # 回路を最適化
  pm = generate_preset_pass_manager(backend=backend, optimization_level=1)
  isa_qc = pm.run(qc)
  # Samplerで実行
  sampler = Sampler(backend)
  job = sampler.run([isa_qc])
  result = job.result()

  #  測定された回数を表示
  counts = result[0].data.c.get_counts()
  print(f" > Counts: {counts}")

  ## ヒストグラムで測定された確率をプロット
  from qiskit.visualization import plot_histogram
  plot_histogram( counts )
  ```