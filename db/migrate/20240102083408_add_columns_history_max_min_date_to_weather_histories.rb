class AddColumnsHistoryMaxMinDateToWeatherHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :weather_histories do |t|
      t.json 'history', null: false

      t.timestamps
    end
  end
end
