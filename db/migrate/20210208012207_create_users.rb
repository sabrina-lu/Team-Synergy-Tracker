class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :watiam, null: false, limit: 50
      t.integer :user_id, unique: true
      t.string :password, null: false, limit: 100
      t.string :first_name, null: false, limit: 50
      t.string :last_name, null: false, limit: 50

      t.timestamps
    end
  end
end
