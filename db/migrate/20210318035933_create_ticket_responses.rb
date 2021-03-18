class CreateTicketResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :ticket_responses do |t|
      t.references :ticket, null: false, foreign_key: true
      t.integer :question_number, null:false
      t.integer :answer, null:false
      t.integer :rating, null:false
    end
  end
end
