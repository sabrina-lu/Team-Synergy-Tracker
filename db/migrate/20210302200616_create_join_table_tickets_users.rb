class CreateJoinTableTicketsUsers < ActiveRecord::Migration[6.0]
  def change
    create_join_table :tickets, :users do |t|
      # t.index [:ticket_id, :user_id]
      t.index [:user_id, :ticket_id], unique: true
    end
  end
end
