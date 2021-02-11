class CreateManagers < ActiveRecord::Migration[6.0]
  def change
    create_table :managers do |t|
      t.string :watiam, null: false, limit: 50
      t.string :first_name, null: false, limit: 50
      t.string :last_name, null: false, limit: 50
      t.string :password_digest, null: false, limit: 100
        
      t.timestamps
    end
  end
end
