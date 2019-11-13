# researchmap-scripts

1. Researchmap から export した業績を加工して PDF を生成する
2. Researchmap に import するための CSV を生成する

## Export: Researchmap => PDF

1. 項目ごとにexport して保存
    * `paper.csv`, `conference.csv`, `competitiveFund.csv`
1. CSV を YAML に変換
    * `ruby csv2yaml.rb [paper|conference|competitiveFund]`: =>  `[paper|conference|competitiveFund].yaml`
1. YAML を編集
    * `ruby yaml2yaml [paper|conference]`
    * TeX 記法への変換（上付き，特殊文字など）
    * 自分の名前に下線を入れる
    * 著者名の正規化 等
1. YAML を TeX に変換
    * `ruby yaml2tex.rb [paper|conference|competitiveFund]` => `[paper|conference|competitiveFund].tex`
    * `.erb` ファイルの形式で出力
1. PDF の生成
    * `platex works.tex`
    * `dvipdfmx works.dvi`

## Import: YAML => CSV

1. `data/posts` 以下の `.yaml` ファイル群を `.csv` に変換する（まだ）

## その他

* `data/posts/split-yaml.rb`
    * export したデータから posts 以下のファイル群に変換したもの．最初だけ使用．