class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.date :date, null: false
      t.references :creator, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
