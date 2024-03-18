# Ridgepoleについて
## Ridgepoleとは
- Ridgepoleは、migrationを使用しなくてもDBスキーマ管理をできるようにするgem
- デフォルトのRailsでは変更のたびにmigrationファイルを増やす必要があるが、Ridgepoleを使うと"スキーマファイル"を編集することでDBスキーマを更新することができる

## 使い方
- `Schemafile`に記述されたスキーマの定義をDBに適用する
- 以下のコマンドを実行する
```
# 通常
$ ridgepole --config config/database.yml --file db/Schemafile --apply

# rakeで短縮したやつ
$ bundle exec rake ridgepole:apply
```
- `--file db/Schemafile`で参照するSchemafileを指定している（デフォルトではプロジェクトのルートパスからSchemafileを探す）
- `--apply`でSchemafileと実際のDBを比較して反映させる

## オプション
### モードを指定するオプション
#### -a/--apply
- Schemafileと現在のDBのスキーマを比較し、反映する
- --dry-runをつけると発行されるSQLを見ることができる
#### -e/--export
- 現在のDBのスキーマをダンプして、Schemafileの形式で書き出す
#### -d/--diff DSL1 DSL2
- 2つのSchemafileを比較して、差分のSQLを見ることができる

### 反映の仕方を指定するオプション
#### -m/--merge
- 差分のうち、カラムやテーブルを足す操作のみ行う
#### -t/--table
- 差分のうち、指定したテーブルの操作のみ行う
#### --mysql-系
- MySQL特有の操作の変更を行う

## 公式リポジトリ
- https://github.com/ridgepole/ridgepole

## 参考
- https://qiita.com/tetz-akaneya/items/d10570aeb028fc603b86