namespace :ridgepole do
  # `Schemafile`に記述されたスキーマの定義をDBに適用する
  desc 'Apply database schema'
  task apply: :environment do
    ridgepole('--apply', "--file #{schema_file}")
  end

  # DBの現在のスキーマを`Schemafile`にエクスポートする
  desc 'Export database schema'
  task export: :environment do
    ridgepole('--export', "--output #{schema_file}")
  end

  private

  # Schemafileのパスを返す
  def schema_file
    Rails.root.join('db/Schemafile')
  end

  # `config/database.ymlのパスを返す`
  def config_file
    Rails.root.join('config/database.yml')
  end

  # 引数のオプションを使用してRidgepoleコマンドを実行する
  def ridgepole(*options)
    command = ['bundle exec ridgepole', "--config #{config_file}"]
    system [command + options].join(' ')
  end
end
