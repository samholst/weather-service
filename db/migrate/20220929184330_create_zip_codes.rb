class CreateZipCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :zip_codes do |t|
      t.integer :code, null: false
      t.decimal :high, precision: 4, scale: 1
      t.decimal :low, precision: 4, scale: 1
      t.decimal :current_temp, precision: 4, scale: 1
      t.text :extended_forecast
      t.decimal :lat, precision: 8, scale: 6
      t.decimal :lon, precision: 9, scale: 6
      t.timestamp :last_cached_at

      t.timestamps
    end

    add_index :zip_codes, [:code, :last_cached_at]
  end
end
