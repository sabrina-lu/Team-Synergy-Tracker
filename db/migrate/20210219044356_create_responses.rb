class CreateResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :responses do |t|
      t.references :survey, null: false, foreign_key: true
      t.integer :question_number, null:false
      t.integer :response, null:false
      
      t.timestamps
    end
  end
end
