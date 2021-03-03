class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.integer :priority, null: false
      t.string :type, null: false
      t.string :category, null: false
      t.string :description, limit: 500, null: false
      t.date :date, null: false
      t.references :creator, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
