class CreateAccessKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :access_keys do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token, null: false

      t.timestamps
    end

    add_index :access_keys, :token
  end
end
